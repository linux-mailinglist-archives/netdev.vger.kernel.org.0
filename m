Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9271453F877
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiFGIpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiFGIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:45:50 -0400
Received: from EX-PRD-EDGE01.vmware.com (EX-PRD-EDGE01.vmware.com [208.91.3.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C740AD4102;
        Tue,  7 Jun 2022 01:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=ye2AXpXM8HdfpBAnmf0gC/E5GIezfSWTFYYONI/trtQ=;
    b=UsspGEZbMkMIqBOax6bCydKkFeiOPoQMpU06qefutQcZNYpMJQogW3blogrPE9
      K1DwX7V1w0Hb6dGR02Rht798Zns9YlwikEHRO3ZxpZwQJlZiQt+vTrBRcW0cxm
      DmyE/0E4eDAKpiXbdZEgsn47lsxRWnvkWWb8g/NFRJFhwZA=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE01.vmware.com (10.188.245.6) with Microsoft SMTP Server id
 15.1.2308.20; Tue, 7 Jun 2022 01:45:22 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id DA6DF201C3;
        Tue,  7 Jun 2022 01:45:36 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id CDE3DAA2B0; Tue,  7 Jun 2022 01:45:36 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 2/8] vmxnet3: add support for capability registers
Date:   Tue, 7 Jun 2022 01:45:12 -0700
Message-ID: <20220607084518.30316-3-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220607084518.30316-1-doshir@vmware.com>
References: <20220607084518.30316-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE01.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enhances vmxnet3 to suuport capability registers which
allows it to enable features selectively. The DCR register tracks
the capabilities vmxnet3 device supports. The PTCR register states
the capabilities that the passthrough device supports.

With the help of these registers, vmxnet3 can enable only those
features which the passthrough device supoprts. This allows
smooth trasition to Uniform-Passthrough (UPT) mode if the virtual
nic requests it. If PTCR register returns nothing or error it means
UPT is not being requested and vnic will continue in emulation mode.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h    |  37 ++++++++++++-
 drivers/net/vmxnet3/vmxnet3_drv.c     |  97 ++++++++++++++++++++++++++++++++
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 101 ++++++++++++++++++++++++++++++++--
 drivers/net/vmxnet3/vmxnet3_int.h     |   4 ++
 4 files changed, 233 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index 9f91ebb10137..0157155ff677 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -40,7 +40,13 @@ enum {
 	VMXNET3_REG_MACL	= 0x28,	/* MAC Address Low */
 	VMXNET3_REG_MACH	= 0x30,	/* MAC Address High */
 	VMXNET3_REG_ICR		= 0x38,	/* Interrupt Cause Register */
-	VMXNET3_REG_ECR		= 0x40	/* Event Cause Register */
+	VMXNET3_REG_ECR		= 0x40, /* Event Cause Register */
+	VMXNET3_REG_DCR         = 0x48, /* Device capability register,
+					 * from 0x48 to 0x80
+					 */
+	VMXNET3_REG_PTCR        = 0x88, /* Passthru capbility register
+					 * from 0x88 to 0xb0
+					 */
 };
 
 /* BAR 0 */
@@ -101,6 +107,9 @@ enum {
 	VMXNET3_CMD_GET_RESERVED2,
 	VMXNET3_CMD_GET_RESERVED3,
 	VMXNET3_CMD_GET_MAX_QUEUES_CONF,
+	VMXNET3_CMD_GET_RESERVED4,
+	VMXNET3_CMD_GET_MAX_CAPABILITIES,
+	VMXNET3_CMD_GET_DCR0_REG,
 };
 
 /*
@@ -801,4 +810,30 @@ struct Vmxnet3_DriverShared {
 #define VMXNET3_LINK_UP         (10000 << 16 | 1)    /* 10 Gbps, up */
 #define VMXNET3_LINK_DOWN       0
 
+#define VMXNET3_DCR_ERROR                          31   /* error when bit 31 of DCR is set */
+#define VMXNET3_CAP_UDP_RSS                        0    /* bit 0 of DCR 0 */
+#define VMXNET3_CAP_ESP_RSS_IPV4                   1    /* bit 1 of DCR 0 */
+#define VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD        2    /* bit 2 of DCR 0 */
+#define VMXNET3_CAP_GENEVE_TSO                     3    /* bit 3 of DCR 0 */
+#define VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD         4    /* bit 4 of DCR 0 */
+#define VMXNET3_CAP_VXLAN_TSO                      5    /* bit 5 of DCR 0 */
+#define VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD  6    /* bit 6 of DCR 0 */
+#define VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD   7    /* bit 7 of DCR 0 */
+#define VMXNET3_CAP_PKT_STEERING_IPV4              8    /* bit 8 of DCR 0 */
+#define VMXNET3_CAP_VERSION_4_MAX                  VMXNET3_CAP_PKT_STEERING_IPV4
+#define VMXNET3_CAP_ESP_RSS_IPV6                   9    /* bit 9 of DCR 0 */
+#define VMXNET3_CAP_VERSION_5_MAX                  VMXNET3_CAP_ESP_RSS_IPV6
+#define VMXNET3_CAP_ESP_OVER_UDP_RSS               10   /* bit 10 of DCR 0 */
+#define VMXNET3_CAP_INNER_RSS                      11   /* bit 11 of DCR 0 */
+#define VMXNET3_CAP_INNER_ESP_RSS                  12   /* bit 12 of DCR 0 */
+#define VMXNET3_CAP_CRC32_HASH_FUNC                13   /* bit 13 of DCR 0 */
+#define VMXNET3_CAP_VERSION_6_MAX                  VMXNET3_CAP_CRC32_HASH_FUNC
+#define VMXNET3_CAP_OAM_FILTER                     14   /* bit 14 of DCR 0 */
+#define VMXNET3_CAP_ESP_QS                         15   /* bit 15 of DCR 0 */
+#define VMXNET3_CAP_LARGE_BAR                      16   /* bit 16 of DCR 0 */
+#define VMXNET3_CAP_OOORX_COMP                     17   /* bit 17 of DCR 0 */
+#define VMXNET3_CAP_VERSION_7_MAX                  18
+/* when new capability is introduced, update VMXNET3_CAP_MAX */
+#define VMXNET3_CAP_MAX                            VMXNET3_CAP_VERSION_7_MAX
+
 #endif /* _VMXNET3_DEFS_H_ */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6fc6a2a26161..edc4f23d4965 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -130,6 +130,20 @@ vmxnet3_tq_stop(struct vmxnet3_tx_queue *tq, struct vmxnet3_adapter *adapter)
 	netif_stop_subqueue(adapter->netdev, (tq - adapter->tx_queue));
 }
 
+/* Check if capability is supported by UPT device or
+ * UPT is even requested
+ */
+bool
+vmxnet3_check_ptcapability(u32 cap_supported, u32 cap)
+{
+	if (cap_supported & (1UL << VMXNET3_DCR_ERROR) ||
+	    cap_supported & (1UL << cap)) {
+		return true;
+	}
+
+	return false;
+}
+
 
 /*
  * Check the link state. This may start or stop the tx queue.
@@ -2671,6 +2685,36 @@ vmxnet3_init_rssfields(struct vmxnet3_adapter *adapter)
 		adapter->rss_fields =
 			VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
 	} else {
+		if (VMXNET3_VERSION_GE_7(adapter)) {
+			if ((adapter->rss_fields & VMXNET3_RSS_FIELDS_UDPIP4 ||
+			     adapter->rss_fields & VMXNET3_RSS_FIELDS_UDPIP6) &&
+			    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+						       VMXNET3_CAP_UDP_RSS)) {
+				adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_UDP_RSS;
+			} else {
+				adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_UDP_RSS);
+			}
+
+			if ((adapter->rss_fields & VMXNET3_RSS_FIELDS_ESPIP4) &&
+			    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+						       VMXNET3_CAP_ESP_RSS_IPV4)) {
+				adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_ESP_RSS_IPV4;
+			} else {
+				adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_ESP_RSS_IPV4);
+			}
+
+			if ((adapter->rss_fields & VMXNET3_RSS_FIELDS_ESPIP6) &&
+			    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+						       VMXNET3_CAP_ESP_RSS_IPV6)) {
+				adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_ESP_RSS_IPV6;
+			} else {
+				adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_ESP_RSS_IPV6);
+			}
+
+			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
+			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD, VMXNET3_CMD_GET_DCR0_REG);
+			adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		}
 		cmdInfo->setRssFields = adapter->rss_fields;
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
 				       VMXNET3_CMD_SET_RSS_FIELDS);
@@ -3185,6 +3229,47 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 			NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		unsigned long flags;
+
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_TSO)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_TSO;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_TSO)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_TSO;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD;
+		}
+
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
+		spin_lock_irqsave(&adapter->cmd_lock, flags);
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD, VMXNET3_CMD_GET_DCR0_REG);
+		adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+
+		if (!(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) &&
+		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD))) {
+			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev->features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		}
+	}
+
 	netdev->vlan_features = netdev->hw_features &
 				~(NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX);
@@ -3520,6 +3605,18 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		goto err_ver;
 	}
 
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		adapter->devcap_supported[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_DCR);
+		adapter->ptcap_supported[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_PTCR);
+		if (adapter->dev_caps[0])
+			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
+
+		spin_lock_irqsave(&adapter->cmd_lock, flags);
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD, VMXNET3_CMD_GET_DCR0_REG);
+		adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+	}
+
 	if (VMXNET3_VERSION_GE_6(adapter)) {
 		spin_lock_irqsave(&adapter->cmd_lock, flags);
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index e41e76757c5b..458f2da1ebab 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -298,7 +298,7 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 	return features;
 }
 
-static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
+static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -306,8 +306,50 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
 		netdev->hw_enc_features |= NETIF_F_SG | NETIF_F_RXCSUM |
 			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
 			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			NETIF_F_LRO;
+		if (features & NETIF_F_GSO_UDP_TUNNEL)
+			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		unsigned long flags;
+
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_TSO)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_TSO;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_TSO)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_TSO;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD;
+		}
+		if (vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+					       VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD)) {
+			adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD;
+		}
+
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
+		spin_lock_irqsave(&adapter->cmd_lock, flags);
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD, VMXNET3_CMD_GET_DCR0_REG);
+		adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+
+		if (!(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) &&
+		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD))) {
+			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		}
 	}
 }
 
@@ -322,6 +364,22 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
 			NETIF_F_GSO_UDP_TUNNEL_CSUM);
 	}
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		unsigned long flags;
+
+		adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_GENEVE_CHECKSUM_OFFLOAD |
+					  1UL << VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD  |
+					  1UL << VMXNET3_CAP_GENEVE_TSO |
+					  1UL << VMXNET3_CAP_VXLAN_TSO  |
+					  1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD |
+					  1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD);
+
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
+		spin_lock_irqsave(&adapter->cmd_lock, flags);
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD, VMXNET3_CMD_GET_DCR0_REG);
+		adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+	}
 }
 
 int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
@@ -357,8 +415,8 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			adapter->shared->devRead.misc.uptFeatures &=
 			~UPT1_F_RXVLAN;
 
-		if ((features & tun_offload_mask) != 0 && !udp_tun_enabled) {
-			vmxnet3_enable_encap_offloads(netdev);
+		if ((features & tun_offload_mask) != 0) {
+			vmxnet3_enable_encap_offloads(netdev, features);
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXINNEROFLD;
 		} else if ((features & tun_offload_mask) == 0 &&
@@ -913,6 +971,39 @@ vmxnet3_set_rss_hash_opt(struct net_device *netdev,
 			union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
 			unsigned long flags;
 
+			if (VMXNET3_VERSION_GE_7(adapter)) {
+				if ((rss_fields & VMXNET3_RSS_FIELDS_UDPIP4 ||
+				     rss_fields & VMXNET3_RSS_FIELDS_UDPIP6) &&
+				    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+							       VMXNET3_CAP_UDP_RSS)) {
+					adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_UDP_RSS;
+				} else {
+					adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_UDP_RSS);
+				}
+				if ((rss_fields & VMXNET3_RSS_FIELDS_ESPIP4) &&
+				    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+							       VMXNET3_CAP_ESP_RSS_IPV4)) {
+					adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_ESP_RSS_IPV4;
+				} else {
+					adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_ESP_RSS_IPV4);
+				}
+				if ((rss_fields & VMXNET3_RSS_FIELDS_ESPIP6) &&
+				    vmxnet3_check_ptcapability(adapter->ptcap_supported[0],
+							       VMXNET3_CAP_ESP_RSS_IPV6)) {
+					adapter->dev_caps[0] |= 1UL << VMXNET3_CAP_ESP_RSS_IPV6;
+				} else {
+					adapter->dev_caps[0] &= ~(1UL << VMXNET3_CAP_ESP_RSS_IPV6);
+				}
+
+				VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR,
+						       adapter->dev_caps[0]);
+				spin_lock_irqsave(&adapter->cmd_lock, flags);
+				VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+						       VMXNET3_CMD_GET_DCR0_REG);
+				adapter->dev_caps[0] = VMXNET3_READ_BAR1_REG(adapter,
+									     VMXNET3_REG_CMD);
+				spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+			}
 			spin_lock_irqsave(&adapter->cmd_lock, flags);
 			cmdInfo->setRssFields = rss_fields;
 			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 5251c3439d6a..a7c8f80702c2 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -403,6 +403,9 @@ struct vmxnet3_adapter {
 	dma_addr_t pm_conf_pa;
 	dma_addr_t rss_conf_pa;
 	bool   queuesExtEnabled;
+	u32    devcap_supported[8];
+	u32    ptcap_supported[8];
+	u32    dev_caps[8];
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
@@ -497,6 +500,7 @@ void vmxnet3_set_ethtool_ops(struct net_device *netdev);
 
 void vmxnet3_get_stats64(struct net_device *dev,
 			 struct rtnl_link_stats64 *stats);
+bool vmxnet3_check_ptcapability(u32 cap_supported, u32 cap);
 
 extern char vmxnet3_driver_name[];
 #endif
-- 
2.11.0

