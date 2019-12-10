Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDF4118215
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLJIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:20:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39867 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:20:45 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so8672379pfx.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 00:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=A8mOoXUA7QLZCrLNOzCsQ4Ra2m9U3gPNtLlOEAF7DPw=;
        b=ok+/43OMw8FDd0FlQoBg/CXqlz+2cjCeqcK4RTO7mhGoi43zRbwp4OQfoMeYpATrEI
         vi0yvOlFjgMVNJPQ24wMBPXWXt3JQQdvqlzlL1a+uVKYb/97bWHuV5xG4CsD9YX5RxmD
         cq5zMgGgrKlePdokLgNkfDofm8llBWIlrLbJ2I0GAw3yp+KLTD5E1bUymDr+4xrnA+9b
         27z+GKbGb3qVUV7R+Fr1UNwtYg8tA34E2bx3JmqZjpBryyi5UTfU8E85uHVpljGwtS4y
         b1GJdI5cs1kht5fY8YEU2r4ZN3sCgTuwbStnvBhLrqc7zS8OqKaDJgUY6NRmF5faUyiK
         VgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A8mOoXUA7QLZCrLNOzCsQ4Ra2m9U3gPNtLlOEAF7DPw=;
        b=Rev33xm7e5+8X53xcoaFKabFM2YBWZ+iPYenuxaCIlahoHHrpyE/5mJPuEXK4eI6Be
         YS4EkDBUEhmYIQb+jHNcffCjgk9wlxrVY1WLMwNwq56Xm/HG66sBUVbxz3HT5q7v2vwk
         7s4W7zlg/uKzwCRcsfdA9zVvbmJCj2B3FAQLDIhWWfWazSrwBvoOcQYftZId5iayltsp
         +7AJA8sr6sEpW/XvzLAz9+8Zq+B25daWAq9s8o7Vw+zl6xZp14+Qg4DmlTbmBQ05M5i8
         QH4FMXhE+CaIIy1xAhW5DLAYv0tvnBKjO/nHiw4jhoiRBPPINtghhheIAlDz7Yehnlz8
         cCrA==
X-Gm-Message-State: APjAAAVcJeR7TvuccAj5Mjsy2OSSIMv5BOZNTbLAUo3VrBDDVeffi+UG
        7ECboz+GTjqOoqOBmRyC1lRRCoI8
X-Google-Smtp-Source: APXvYqwTLpZxnrjolFsnmiPu1ANsLNBE1BE2+Nj7EiM4+Br1i/VS+moN4Uizmvur827ph04kOB+Y1g==
X-Received: by 2002:a65:4109:: with SMTP id w9mr11618849pgp.383.1575966043973;
        Tue, 10 Dec 2019 00:20:43 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([1.39.147.184])
        by smtp.gmail.com with ESMTPSA id a13sm2267776pfc.40.2019.12.10.00.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 00:20:43 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH v2] Encap & Decap actions for MPLS Packet Type
Date:   Tue, 10 Dec 2019 13:50:02 +0530
Message-Id: <1575966002-4605-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
between ethernet header and the IP header. Though this behaviour is fine
for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
does not suffice the L2 VPN requirements. In L2 VPN the ethernet packets
must be encapsulated inside MPLS tunnel

In this change the encap & decap actions are extended to support MPLS
packet type. The encap & decap adds and removes MPLS header at the start
of packet as depicted below.

Encapsulation:

Actions - encap(mpls(ether_type=0x8847)),encap(ethernet)

Incoming packet -> | ETH | IP | Payload |

1 Actions -  encap(mpls(ether_type=0x8847)) [Kernel action -
ptap_push_mpls:0x8847]

        Outgoing packet -> | MPLS | ETH | Payload|

2 Actions - encap(ethernet) [ Kernel action - push_eth ]

        Outgoing packet -> | ETH | MPLS | ETH | Payload|

Decapsulation:

Incoming packet -> | ETH | MPLS | ETH | IP | Payload |

Actions - decap(),decap(packet_type(ns=0,type=0)

1 Actions -  decap() [Kernel action - pop_eth)

        Outgoing packet -> | MPLS | ETH | IP | Payload|

2 Actions - decap(packet_type(ns=0,type=0) [Kernel action -
ptap_pop_mpls:0]

        Outgoing packet -> | ETH  | IP | Payload

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 datapath/actions.c                                | 56 ++++++++++++++
 datapath/flow_netlink.c                           | 21 ++++++
 datapath/linux/compat/include/linux/openvswitch.h |  2 +
 include/openvswitch/ofp-ed-props.h                | 18 +++++
 lib/dpif-netdev.c                                 |  2 +
 lib/dpif.c                                        |  2 +
 lib/odp-execute.c                                 | 14 ++++
 lib/odp-util.c                                    | 49 ++++++++++--
 lib/ofp-actions.c                                 |  5 ++
 lib/ofp-ed-props.c                                | 92 ++++++++++++++++++++++-
 lib/packets.c                                     | 28 +++++++
 lib/packets.h                                     |  3 +-
 ofproto/ofproto-dpif-ipfix.c                      |  2 +
 ofproto/ofproto-dpif-sflow.c                      |  2 +
 ofproto/ofproto-dpif-xlate.c                      | 54 +++++++++++++
 tests/system-traffic.at                           | 34 +++++++++
 16 files changed, 376 insertions(+), 8 deletions(-)

diff --git a/datapath/actions.c b/datapath/actions.c
index fbf4457..1d0d904 100644
--- a/datapath/actions.c
+++ b/datapath/actions.c
@@ -256,6 +256,54 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 	return 0;
 }
 
+static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
+                const struct ovs_action_push_mpls *mpls)
+{
+
+        struct mpls_shim_hdr *lse;
+        int err;
+
+        if (unlikely(!eth_p_mpls(mpls->mpls_ethertype)))
+                return -EINVAL;
+
+        /* Networking stack does not allow simultaneous Tunnel and MPLS GSO. */
+        if (skb->encapsulation)
+                return -EINVAL;
+
+        err = skb_cow_head(skb, MPLS_HLEN);
+        if (unlikely(err))
+                return err;
+
+        if (!skb->inner_protocol) {
+                skb_set_inner_network_header(skb, skb->mac_len);
+                skb_set_inner_protocol(skb, skb->protocol);
+        }
+
+        skb_push(skb, MPLS_HLEN);
+        skb_reset_mac_header(skb);
+        skb_reset_network_header(skb);
+
+        lse = mpls_hdr(skb);
+        lse->label_stack_entry = mpls->mpls_lse;
+        skb_postpush_rcsum(skb, lse, MPLS_HLEN);
+        skb->protocol = mpls->mpls_ethertype;
+
+        invalidate_flow_key(key);
+        return 0;
+}
+
+static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
+                const __be16 ethertype)
+{
+        if(!ethertype)
+                key->mac_proto = MAC_PROTO_ETHERNET;
+
+        pop_mpls(skb, key, ethertype);
+        invalidate_flow_key(key);
+        return 0;
+}
+
+
 static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		    const __be32 *mpls_lse, const __be32 *mask)
 {
@@ -1313,10 +1361,18 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			err = push_mpls(skb, key, nla_data(a));
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+                        err = push_ptap_mpls(skb, key, nla_data(a));
+                        break;
+
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
 
+		 case OVS_ACTION_ATTR_PTAP_POP_MPLS:
+                        err = ptap_pop_mpls(skb, key, nla_get_be16(a));
+                        break;
+
 		case OVS_ACTION_ATTR_PUSH_VLAN:
 			err = push_vlan(skb, key, nla_data(a));
 			break;
diff --git a/datapath/flow_netlink.c b/datapath/flow_netlink.c
index 9fc1a19..46d77d2 100644
--- a/datapath/flow_netlink.c
+++ b/datapath/flow_netlink.c
@@ -94,6 +94,8 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_SET_MASKED:
 		case OVS_ACTION_ATTR_METER:
 		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+		case OVS_ACTION_ATTR_PTAP_POP_MPLS:
 		default:
 			return true;
 		}
@@ -3001,6 +3003,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_METER] = sizeof(u32),
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
+			[OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_push_mpls),
+			[OVS_ACTION_ATTR_PTAP_POP_MPLS] = sizeof(__be16),
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3068,6 +3072,19 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_RECIRC:
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+			const struct ovs_action_push_mpls *mpls = nla_data(a);
+
+			eth_type = mpls->mpls_ethertype;			
+			if (mac_proto != MAC_PROTO_NONE) {
+				mpls_label_count = 1;
+				mac_proto = MAC_PROTO_NONE;		
+			} else {
+				mpls_label_count++;
+			} 
+			break;
+		}
+
 		case OVS_ACTION_ATTR_PUSH_MPLS: {
 			const struct ovs_action_push_mpls *mpls = nla_data(a);
 
@@ -3088,6 +3105,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			break;
 		}
 
+		case OVS_ACTION_ATTR_PTAP_POP_MPLS:
+			if (mac_proto != MAC_PROTO_NONE)
+				return -EINVAL;
+
 		case OVS_ACTION_ATTR_POP_MPLS: {
 			__be16  proto;
 			if (vlan_tci & htons(VLAN_CFI_MASK) ||
diff --git a/datapath/linux/compat/include/linux/openvswitch.h b/datapath/linux/compat/include/linux/openvswitch.h
index 778827f..2088b44 100644
--- a/datapath/linux/compat/include/linux/openvswitch.h
+++ b/datapath/linux/compat/include/linux/openvswitch.h
@@ -990,6 +990,8 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter number. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_PTAP_PUSH_MPLS,    /* struct ovs_action_push_mpls. */
+	OVS_ACTION_ATTR_PTAP_POP_MPLS,     /* __be16 ethertype. */
 
 #ifndef __KERNEL__
 	OVS_ACTION_ATTR_TUNNEL_PUSH,   /* struct ovs_action_push_tnl*/
diff --git a/include/openvswitch/ofp-ed-props.h b/include/openvswitch/ofp-ed-props.h
index 306c6fe..9ddfaec 100644
--- a/include/openvswitch/ofp-ed-props.h
+++ b/include/openvswitch/ofp-ed-props.h
@@ -46,6 +46,11 @@ enum ofp_ed_nsh_prop_type {
     OFPPPT_PROP_NSH_TLV = 2,     /* property TLV in NSH */
 };
 
+enum ofp_ed_mpls_prop_type {
+    OFPPPT_PROP_MPLS_NONE = 0,    /* unused */
+    OFPPPT_PROP_MPLS_ETHERTYPE = 1,  /* MPLS Ethertype */
+};
+
 /*
  * External representation of encap/decap properties.
  * These must be padded to a multiple of 8 bytes.
@@ -72,6 +77,13 @@ struct ofp_ed_prop_nsh_tlv {
     uint8_t data[0];
 };
 
+struct ofp_ed_prop_mpls_ethertype {
+    struct ofp_ed_prop_header header;
+    uint16_t ether_type;         /* MPLS ethertype .*/
+    uint8_t pad[2];          /* Padding to 8 bytes. */
+};
+
+
 /*
  * Internal representation of encap/decap properties
  */
@@ -96,6 +108,12 @@ struct ofpact_ed_prop_nsh_tlv {
     /* tlv_len octets of metadata value, padded to a multiple of 8 bytes. */
     uint8_t data[0];
 };
+
+struct ofpact_ed_prop_mpls_ethertype {
+    struct ofpact_ed_prop header;
+    uint16_t ether_type;         /* MPLS ethertype .*/
+    uint8_t pad[2];          /* Padding to 2 bytes. */
+};
 enum ofperr decode_ed_prop(const struct ofp_ed_prop_header **ofp_prop,
                            struct ofpbuf *out, size_t *remaining);
 enum ofperr encode_ed_prop(const struct ofpact_ed_prop **prop,
diff --git a/lib/dpif-netdev.c b/lib/dpif-netdev.c
index 5142bad..81b0760 100644
--- a/lib/dpif-netdev.c
+++ b/lib/dpif-netdev.c
@@ -7335,6 +7335,8 @@ dp_execute_cb(void *aux_, struct dp_packet_batch *packets_,
     case OVS_ACTION_ATTR_POP_VLAN:
     case OVS_ACTION_ATTR_PUSH_MPLS:
     case OVS_ACTION_ATTR_POP_MPLS:
+    case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+    case OVS_ACTION_ATTR_PTAP_POP_MPLS:
     case OVS_ACTION_ATTR_SET:
     case OVS_ACTION_ATTR_SET_MASKED:
     case OVS_ACTION_ATTR_SAMPLE:
diff --git a/lib/dpif.c b/lib/dpif.c
index c88b210..a27ff97 100644
--- a/lib/dpif.c
+++ b/lib/dpif.c
@@ -1274,6 +1274,8 @@ dpif_execute_helper_cb(void *aux_, struct dp_packet_batch *packets_,
     case OVS_ACTION_ATTR_CT_CLEAR:
     case OVS_ACTION_ATTR_UNSPEC:
     case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+    case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+    case OVS_ACTION_ATTR_PTAP_POP_MPLS:
     case __OVS_ACTION_ATTR_MAX:
         OVS_NOT_REACHED();
     }
diff --git a/lib/odp-execute.c b/lib/odp-execute.c
index 563ad1d..0b2c367 100644
--- a/lib/odp-execute.c
+++ b/lib/odp-execute.c
@@ -749,6 +749,8 @@ requires_datapath_assistance(const struct nlattr *a)
     case OVS_ACTION_ATTR_POP_NSH:
     case OVS_ACTION_ATTR_CT_CLEAR:
     case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+    case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+    case OVS_ACTION_ATTR_PTAP_POP_MPLS:
         return false;
 
     case OVS_ACTION_ATTR_UNSPEC:
@@ -876,12 +878,24 @@ odp_execute_actions(void *dp, struct dp_packet_batch *batch, bool steal,
             }
             break;
          }
+         case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+            const struct ovs_action_push_mpls *mpls = nl_attr_get(a);
 
+            DP_PACKET_BATCH_FOR_EACH (i, packet, batch) {
+                ptap_push_mpls(packet, mpls->mpls_ethertype, mpls->mpls_lse);
+            }
+            break;
+         }
         case OVS_ACTION_ATTR_POP_MPLS:
             DP_PACKET_BATCH_FOR_EACH (i, packet, batch) {
                 pop_mpls(packet, nl_attr_get_be16(a));
             }
             break;
+        case OVS_ACTION_ATTR_PTAP_POP_MPLS:
+            DP_PACKET_BATCH_FOR_EACH (i, packet, batch) {
+                ptap_pop_mpls(packet, nl_attr_get_be16(a));
+            }
+            break;
 
         case OVS_ACTION_ATTR_SET:
             DP_PACKET_BATCH_FOR_EACH (i, packet, batch) {
diff --git a/lib/odp-util.c b/lib/odp-util.c
index b9600b4..2e0e4a5 100644
--- a/lib/odp-util.c
+++ b/lib/odp-util.c
@@ -141,6 +141,9 @@ odp_action_len(uint16_t type)
     case OVS_ACTION_ATTR_PUSH_NSH: return ATTR_LEN_VARIABLE;
     case OVS_ACTION_ATTR_POP_NSH: return 0;
     case OVS_ACTION_ATTR_CHECK_PKT_LEN: return ATTR_LEN_VARIABLE;
+    case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+        return sizeof(struct ovs_action_push_mpls);
+    case OVS_ACTION_ATTR_PTAP_POP_MPLS: return sizeof(ovs_be16);
 
     case OVS_ACTION_ATTR_UNSPEC:
     case __OVS_ACTION_ATTR_MAX:
@@ -1207,11 +1210,25 @@ format_odp_action(struct ds *ds, const struct nlattr *a,
         ds_put_format(ds, ",eth_type=0x%"PRIx16")", ntohs(mpls->mpls_ethertype));
         break;
     }
+    case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+        const struct ovs_action_push_mpls *mpls = nl_attr_get(a);
+        ds_put_cstr(ds, "ptap_push_mpls(");
+        format_mpls_lse(ds, mpls->mpls_lse);
+        ds_put_format(ds, ",eth_type=0x%"PRIx16")",
+                      ntohs(mpls->mpls_ethertype));
+        break;
+    }
     case OVS_ACTION_ATTR_POP_MPLS: {
         ovs_be16 ethertype = nl_attr_get_be16(a);
         ds_put_format(ds, "pop_mpls(eth_type=0x%"PRIx16")", ntohs(ethertype));
         break;
     }
+    case OVS_ACTION_ATTR_PTAP_POP_MPLS: {
+        ovs_be16 ethertype = nl_attr_get_be16(a);
+        ds_put_format(ds, "ptap_pop_mpls(eth_type=0x%"PRIx16")",
+                      ntohs(ethertype));
+        break;
+    }
     case OVS_ACTION_ATTR_SAMPLE:
         format_odp_sample_action(ds, a, portno_names);
         break;
@@ -7470,7 +7487,6 @@ odp_put_push_eth_action(struct ofpbuf *odp_actions,
     nl_msg_put_unspec(odp_actions, OVS_ACTION_ATTR_PUSH_ETH,
                       &eth, sizeof eth);
 }
-
 void
 odp_put_tunnel_action(const struct flow_tnl *tunnel,
                       struct ofpbuf *odp_actions, const char *tnl_type)
@@ -7674,7 +7690,8 @@ commit_vlan_action(const struct flow* flow, struct flow *base,
 /* Wildcarding already done at action translation time. */
 static void
 commit_mpls_action(const struct flow *flow, struct flow *base,
-                   struct ofpbuf *odp_actions)
+                   struct ofpbuf *odp_actions,  bool pending_encap,
+                   bool pending_decap)
 {
     int base_n = flow_count_mpls_labels(base, NULL);
     int flow_n = flow_count_mpls_labels(flow, NULL);
@@ -7713,7 +7730,12 @@ commit_mpls_action(const struct flow *flow, struct flow *base,
             } else {
                 dl_type = flow->dl_type;
             }
-            nl_msg_put_be16(odp_actions, OVS_ACTION_ATTR_POP_MPLS, dl_type);
+            if (pending_decap) {
+               nl_msg_put_be16(odp_actions, OVS_ACTION_ATTR_PTAP_POP_MPLS,
+                               dl_type);
+            } else {
+               nl_msg_put_be16(odp_actions, OVS_ACTION_ATTR_POP_MPLS, dl_type);
+            }
             ovs_assert(flow_pop_mpls(base, base_n, flow->dl_type, NULL));
             base_n--;
         }
@@ -7724,9 +7746,16 @@ commit_mpls_action(const struct flow *flow, struct flow *base,
     while (base_n < flow_n) {
         struct ovs_action_push_mpls *mpls;
 
-        mpls = nl_msg_put_unspec_zero(odp_actions,
+        if (!pending_encap) {
+            mpls = nl_msg_put_unspec_zero(odp_actions,
                                       OVS_ACTION_ATTR_PUSH_MPLS,
                                       sizeof *mpls);
+        } else {
+            mpls = nl_msg_put_unspec_zero(odp_actions,
+                                      OVS_ACTION_ATTR_PTAP_PUSH_MPLS,
+                                      sizeof *mpls);
+
+        }
         mpls->mpls_ethertype = flow->dl_type;
         mpls->mpls_lse = flow->mpls_lse[flow_n - base_n - 1];
         /* Update base flow's MPLS stack, but do not clear L3.  We need the L3
@@ -8373,6 +8402,10 @@ commit_encap_decap_action(const struct flow *flow,
             memcpy(&base_flow->dl_dst, &flow->dl_dst,
                    sizeof(*flow) - offsetof(struct flow, dl_dst));
             break;
+        case PT_MPLS:
+             commit_mpls_action(flow, base_flow, odp_actions, pending_encap,
+                                pending_decap);
+             break;
         default:
             /* Only the above protocols are supported for encap.
              * The check is done at action translation. */
@@ -8395,6 +8428,10 @@ commit_encap_decap_action(const struct flow *flow,
                 /* pop_nsh. */
                 odp_put_pop_nsh_action(odp_actions);
                 break;
+            case PT_MPLS:
+                 commit_mpls_action(flow, base_flow, odp_actions,pending_encap,
+                                    pending_decap);
+                 break;
             default:
                 /* Checks are done during translation. */
                 OVS_NOT_REACHED();
@@ -8440,7 +8477,7 @@ commit_odp_actions(const struct flow *flow, struct flow *base,
     /* Make packet a non-MPLS packet before committing L3/4 actions,
      * which would otherwise do nothing. */
     if (eth_type_mpls(base->dl_type) && !eth_type_mpls(flow->dl_type)) {
-        commit_mpls_action(flow, base, odp_actions);
+        commit_mpls_action(flow, base, odp_actions, false, false);
         mpls_done = true;
     }
     commit_set_nsh_action(flow, base, odp_actions, wc, use_masked);
@@ -8448,7 +8485,7 @@ commit_odp_actions(const struct flow *flow, struct flow *base,
     commit_set_port_action(flow, base, odp_actions, wc, use_masked);
     slow2 = commit_set_icmp_action(flow, base, odp_actions, wc);
     if (!mpls_done) {
-        commit_mpls_action(flow, base, odp_actions);
+        commit_mpls_action(flow, base, odp_actions, false, false);
     }
     commit_vlan_action(flow, base, odp_actions, wc);
     commit_set_priority_action(flow, base, odp_actions, wc, use_masked);
diff --git a/lib/ofp-actions.c b/lib/ofp-actions.c
index ddef3b0..fb392fe 100644
--- a/lib/ofp-actions.c
+++ b/lib/ofp-actions.c
@@ -4355,6 +4355,7 @@ decode_NXAST_RAW_ENCAP(const struct nx_action_encap *nae,
     switch (ntohl(nae->new_pkt_type)) {
     case PT_ETH:
     case PT_NSH:
+    case PT_MPLS:
         /* Add supported encap header types here. */
         break;
     default:
@@ -4405,6 +4406,8 @@ parse_encap_header(const char *hdr, ovs_be32 *packet_type)
         *packet_type = htonl(PT_ETH);
     } else if (strcmp(hdr, "nsh") == 0) {
         *packet_type = htonl(PT_NSH);
+    } else if (strcmp(hdr, "mpls") == 0) {
+        *packet_type = htonl(PT_MPLS);
     } else {
         return false;
     }
@@ -4486,6 +4489,8 @@ format_encap_pkt_type(const ovs_be32 pkt_type)
         return "ethernet";
     case PT_NSH:
         return "nsh";
+    case PT_MPLS:
+        return "mpls";
     default:
         return "UNKNOWN";
     }
diff --git a/lib/ofp-ed-props.c b/lib/ofp-ed-props.c
index 28382e0..bacd7e6 100644
--- a/lib/ofp-ed-props.c
+++ b/lib/ofp-ed-props.c
@@ -79,6 +79,27 @@ decode_ed_prop(const struct ofp_ed_prop_header **ofp_prop,
         }
         break;
     }
+    case OFPPPC_MPLS: {
+       switch (prop_type) {
+        case OFPPPT_PROP_MPLS_ETHERTYPE: {
+            struct ofp_ed_prop_mpls_ethertype *opnmt =
+                ALIGNED_CAST(struct ofp_ed_prop_mpls_ethertype *, *ofp_prop);
+            if (len > sizeof(*opnmt) || len > *remaining) {
+                return OFPERR_NXBAC_BAD_ED_PROP;
+            }
+            struct ofpact_ed_prop_mpls_ethertype *pnmt =
+                    ofpbuf_put_uninit(out, sizeof(*pnmt));
+            pnmt->header.prop_class = prop_class;
+            pnmt->header.type = prop_type;
+            pnmt->header.len = len;
+            pnmt->ether_type = opnmt->ether_type;
+            break;
+        }
+        default:
+            return OFPERR_NXBAC_UNKNOWN_ED_PROP;
+        }
+        break;
+    }
     default:
         return OFPERR_NXBAC_UNKNOWN_ED_PROP;
     }
@@ -133,6 +154,27 @@ encode_ed_prop(const struct ofpact_ed_prop **prop,
         }
         break;
     }
+    case OFPPPC_MPLS: {
+       switch ((*prop)->type) {
+       case OFPPPT_PROP_MPLS_ETHERTYPE: {
+           struct ofp_ed_prop_mpls_ethertype *pnmt =
+                ALIGNED_CAST(struct ofp_ed_prop_mpls_ethertype *, *prop);
+            struct ofpact_ed_prop_mpls_ethertype *opnmt =
+                    ofpbuf_put_uninit(out, sizeof(*opnmt));
+            opnmt->header.prop_class = htons((*prop)->prop_class);
+            opnmt->header.type = (*prop)->type;
+            opnmt->header.len =
+                    offsetof(struct ofpact_ed_prop_mpls_ethertype, pad);
+            opnmt->ether_type = pnmt->ether_type;
+            prop_len = sizeof(*pnmt);
+            break;
+
+       }
+       default:
+            return OFPERR_OFPBAC_BAD_ARGUMENT;
+       }
+       break;
+    }
     default:
         return OFPERR_OFPBAC_BAD_ARGUMENT;
     }
@@ -180,6 +222,11 @@ parse_ed_prop_type(uint16_t prop_class,
         } else {
             return false;
         }
+    case OFPPPC_MPLS:
+        if (!strcmp(str, "ether_type")) {
+            *type = OFPPPT_PROP_MPLS_ETHERTYPE;
+            return true;
+        }
     default:
         return false;
     }
@@ -253,11 +300,34 @@ parse_ed_prop_value(uint16_t prop_class, uint8_t prop_type OVS_UNUSED,
             }
             break;
         }
+
         default:
             /* Unsupported property types rejected before. */
             OVS_NOT_REACHED();
         }
-        break;
+       break;
+   case OFPPPC_MPLS:
+     switch (prop_type) {
+            case OFPPPT_PROP_MPLS_ETHERTYPE: {
+            uint16_t ethertype;
+            error = str_to_u16(value, "ether_type", &ethertype);
+            if (error != NULL) {
+                return error;
+            }
+            struct ofpact_ed_prop_mpls_ethertype *pnmt =
+                    ofpbuf_put_uninit(out, sizeof(*pnmt));
+            pnmt->header.prop_class = prop_class;
+            pnmt->header.type = prop_type;
+            pnmt->header.len =
+                    offsetof(struct ofpact_ed_prop_mpls_ethertype, pad);
+            pnmt->ether_type = ethertype;
+
+            break;
+            }
+            default:
+                break;
+      }
+      break;
     default:
         /* Unsupported property classes rejected before. */
         OVS_NOT_REACHED();
@@ -299,6 +369,14 @@ format_ed_prop_type(const struct ofpact_ed_prop *prop)
             OVS_NOT_REACHED();
         }
         break;
+    case OFPPPC_MPLS:
+         switch (prop->type) {
+         case OFPPPT_PROP_MPLS_ETHERTYPE:
+              return "ether_type";
+         default:
+               OVS_NOT_REACHED();
+         }
+         break;
     default:
         OVS_NOT_REACHED();
     }
@@ -331,6 +409,18 @@ format_ed_prop(struct ds *s OVS_UNUSED,
         default:
             OVS_NOT_REACHED();
         }
+     case OFPPPC_MPLS:
+        switch (prop->type) {
+        case OFPPPT_PROP_MPLS_ETHERTYPE: {
+          struct ofpact_ed_prop_mpls_ethertype *pnmt =
+                ALIGNED_CAST(struct ofpact_ed_prop_mpls_ethertype *, prop);
+            ds_put_format(s, "%s=%d", format_ed_prop_type(prop),
+                          pnmt->ether_type);
+            return;
+        }
+        default:
+            OVS_NOT_REACHED();
+        }
     default:
         OVS_NOT_REACHED();
     }
diff --git a/lib/packets.c b/lib/packets.c
index 9d7cc50..404fe80 100644
--- a/lib/packets.c
+++ b/lib/packets.c
@@ -395,6 +395,24 @@ push_mpls(struct dp_packet *packet, ovs_be16 ethtype, ovs_be32 lse)
     pkt_metadata_init_conn(&packet->md);
 }
 
+/* Push MPLS label stack entry 'lse' onto 'packet' as the outermost MPLS
+ *  * header.  If 'packet' does not already have any MPLS labels, then its
+ *   * Ethertype is changed to 'ethtype' (which must be an MPLS Ethertype). */
+void
+ptap_push_mpls(struct dp_packet *packet, ovs_be16 ethtype, ovs_be32 lse)
+{
+    char * header;
+
+    if (!eth_type_mpls(ethtype)) {
+        return;
+    }
+    header =  dp_packet_push_uninit(packet, MPLS_HLEN);
+    memcpy(header, &lse, sizeof lse);
+    packet->l2_5_ofs = 0;
+    packet->packet_type = htonl(PT_MPLS);
+}
+
+
 /* If 'packet' is an MPLS packet, removes its outermost MPLS label stack entry.
  * If the label that was removed was the only MPLS label, changes 'packet''s
  * Ethertype to 'ethtype' (which ordinarily should not be an MPLS
@@ -421,6 +439,16 @@ pop_mpls(struct dp_packet *packet, ovs_be16 ethtype)
 }
 
 void
+ptap_pop_mpls(struct dp_packet *packet, ovs_be16 ethtype)
+{
+    if (!ethtype) {
+        packet->packet_type = htonl(PT_ETH);
+    }
+    pop_mpls(packet, ethtype);
+}
+
+
+void
 push_nsh(struct dp_packet *packet, const struct nsh_hdr *nsh_hdr_src)
 {
     struct nsh_hdr *nsh;
diff --git a/lib/packets.h b/lib/packets.h
index 5d7f82c..d6ce010 100644
--- a/lib/packets.h
+++ b/lib/packets.h
@@ -358,7 +358,8 @@ void set_mpls_lse_label(ovs_be32 *lse, ovs_be32 label);
 void set_mpls_lse_bos(ovs_be32 *lse, uint8_t bos);
 ovs_be32 set_mpls_lse_values(uint8_t ttl, uint8_t tc, uint8_t bos,
                              ovs_be32 label);
-
+void ptap_push_mpls(struct dp_packet *packet, ovs_be16 ethtype, ovs_be32 lse);
+void ptap_pop_mpls(struct dp_packet *packet, ovs_be16 ethtype);
 /* Example:
  *
  * struct eth_addr mac;
diff --git a/ofproto/ofproto-dpif-ipfix.c b/ofproto/ofproto-dpif-ipfix.c
index b8bd1b8..59cdb41 100644
--- a/ofproto/ofproto-dpif-ipfix.c
+++ b/ofproto/ofproto-dpif-ipfix.c
@@ -3015,6 +3015,8 @@ dpif_ipfix_read_actions(const struct flow *flow,
         case OVS_ACTION_ATTR_PUSH_NSH:
         case OVS_ACTION_ATTR_POP_NSH:
         case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+        case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+        case OVS_ACTION_ATTR_PTAP_POP_MPLS:
         case OVS_ACTION_ATTR_UNSPEC:
         case __OVS_ACTION_ATTR_MAX:
         default:
diff --git a/ofproto/ofproto-dpif-sflow.c b/ofproto/ofproto-dpif-sflow.c
index 9abaab6..5c166b8 100644
--- a/ofproto/ofproto-dpif-sflow.c
+++ b/ofproto/ofproto-dpif-sflow.c
@@ -1224,6 +1224,8 @@ dpif_sflow_read_actions(const struct flow *flow,
         case OVS_ACTION_ATTR_POP_NSH:
         case OVS_ACTION_ATTR_UNSPEC:
         case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+        case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+        case OVS_ACTION_ATTR_PTAP_POP_MPLS:
         case __OVS_ACTION_ATTR_MAX:
         default:
             break;
diff --git a/ofproto/ofproto-dpif-xlate.c b/ofproto/ofproto-dpif-xlate.c
index cebae7a..853fe0e 100644
--- a/ofproto/ofproto-dpif-xlate.c
+++ b/ofproto/ofproto-dpif-xlate.c
@@ -6306,6 +6306,45 @@ rewrite_flow_encap_ethernet(struct xlate_ctx *ctx,
         ctx->error = XLATE_UNSUPPORTED_PACKET_TYPE;
     }
 }
+static void
+rewrite_flow_encap_mpls(struct xlate_ctx *ctx,
+                        const struct ofpact_encap *encap,
+                        struct flow *flow,
+                        struct flow_wildcards *wc)
+{
+    int n;
+    uint32_t i;
+    uint16_t ether_type;
+    const char *ptr = (char *) encap->props;
+
+     for (i = 0; i < encap->n_props; i++) {
+        struct ofpact_ed_prop *prop_ptr =
+            ALIGNED_CAST(struct ofpact_ed_prop *, ptr);
+        if (prop_ptr->prop_class == OFPPPC_MPLS) {
+            switch (prop_ptr->type) {
+                case OFPPPT_PROP_MPLS_ETHERTYPE: {
+                     struct ofpact_ed_prop_mpls_ethertype *prop_ether_type =
+                        ALIGNED_CAST(struct ofpact_ed_prop_mpls_ethertype *,
+                                     prop_ptr);
+                    ether_type = prop_ether_type->ether_type;
+                    break;
+                 }
+            }
+        }
+     }
+
+    wc->masks.packet_type = OVS_BE32_MAX;
+    if (flow->packet_type != htonl(PT_MPLS)) {
+        memset(&ctx->wc->masks.mpls_lse, 0x0,
+                   sizeof *wc->masks.mpls_lse * FLOW_MAX_MPLS_LABELS);
+        memset(&flow->mpls_lse, 0x0, sizeof *flow->mpls_lse *
+                   FLOW_MAX_MPLS_LABELS);
+    }
+    flow->packet_type = htonl(PT_MPLS);
+    n = flow_count_mpls_labels(flow, ctx->wc);
+    flow_push_mpls(flow, n, htons(ether_type), ctx->wc, true);
+}
+
 
 /* For an MD2 NSH header returns a pointer to an ofpbuf with the encoded
  * MD2 TLVs provided as encap properties to the encap operation. This
@@ -6438,6 +6477,9 @@ xlate_generic_encap_action(struct xlate_ctx *ctx,
         case PT_NSH:
             encap_data = rewrite_flow_push_nsh(ctx, encap, flow, wc);
             break;
+        case PT_MPLS:
+            rewrite_flow_encap_mpls(ctx, encap,  flow, wc);
+            break;
         default:
             /* New packet type was checked during decoding. */
             OVS_NOT_REACHED();
@@ -6507,6 +6549,18 @@ xlate_generic_decap_action(struct xlate_ctx *ctx,
             ctx->pending_decap = true;
             /* Trigger recirculation. */
             return true;
+        case PT_MPLS: {
+             int n;
+             ovs_be16 ethertype;
+
+             flow->packet_type = decap->new_pkt_type;
+             ethertype = pt_ns_type_be(flow->packet_type);
+
+             n = flow_count_mpls_labels(flow, ctx->wc);
+             flow_pop_mpls(flow, n, ethertype, ctx->wc);
+             ctx->pending_decap = true;
+             return true;
+        }
         default:
             /* Error handling: drop packet. */
             xlate_report_debug(
diff --git a/tests/system-traffic.at b/tests/system-traffic.at
index cde7429..44a13ae 100644
--- a/tests/system-traffic.at
+++ b/tests/system-traffic.at
@@ -1024,6 +1024,40 @@ AT_CHECK([ovs-ofctl add-flows br1 flows.txt])
 NS_CHECK_EXEC([at_ns0], [ping -q -c 3 -i 0.3 -w 2 10.1.1.2 | FORMAT_PING], [0], [dnl
 3 packets transmitted, 3 received, 0% packet loss, time 0ms
 ])
+VS_TRAFFIC_VSWITCHD_STOP
+AT_CLEANUP
+
+
+AT_SETUP([datapath - PTAP MPLS Actions])
+OVS_TRAFFIC_VSWITCHD_START([_ADD_BR([br1])])
+
+ADD_NAMESPACES(at_ns0, at_ns1)
+
+ADD_VETH(p0, at_ns0, br0, "10.1.1.1/24")
+ADD_VETH(p1, at_ns1, br1, "10.1.1.2/24")
+
+AT_CHECK([ip link add patch0 type veth peer name patch1])
+on_exit 'ip link del patch0'
+
+AT_CHECK([ip link set dev patch0 up])
+AT_CHECK([ip link set dev patch1 up])
+AT_CHECK([ovs-vsctl add-port br0 patch0 -- set interface patch0 ofport_request=100])
+AT_CHECK([ovs-vsctl add-port br1 patch1 -- set interface patch1 ofport_request=100])
+
+AT_DATA([flows.txt], [dnl
+table=0,priority=100,dl_type=0x0800 actions=encap(mpls(ether_type=0x8847)),set_mpls_label:2,encap(ethernet),output:100
+table=0,priority=100,dl_type=0x8847,mpls_label=2 actions=decap(),decap(packet_type(ns=0,type=0)),resubmit(,3)
+table=0,priority=10 actions=resubmit(,3)
+table=3,priority=10 actions=normal
+])
+
+AT_CHECK([ovs-ofctl  -Oopenflow13 add-flows br0 flows.txt])
+AT_CHECK([ovs-ofctl  -Oopenflow13 add-flows br1 flows.txt])
+
+NS_CHECK_EXEC([at_ns0], [ping -q -c 3 -i 0.3 -w 2 10.1.1.2 | FORMAT_PING], [0], [dnl
+3 packets transmitted, 3 received, 0% packet loss, time 0ms
+])
+
 
 NS_CHECK_EXEC([at_ns1], [ping -q -c 3 -i 0.3 -w 2 10.1.1.1 | FORMAT_PING], [0], [dnl
 3 packets transmitted, 3 received, 0% packet loss, time 0ms
-- 
1.8.3.1

