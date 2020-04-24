Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A24C1B6F01
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDXH2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgDXH2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PoCG021067;
        Fri, 24 Apr 2020 00:28:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mnlYVK/6+6+8ScEl2nbqwBPomCAE34G13MSEqRqXWI4=;
 b=iGgvbEkzuPLbunuIwSj7TWaIzOiqYD9NJHSm47d8HvIbCtDH/GUK6kvRmQM1Xqyumi3m
 bPpeE/fx9rG7AW2oEM0mA1sSYjMzlLdrTOc5wyKn/7PBw5ZFRxwqVEhFmOkW5JYlsmBB
 ImXbEeVrDZE80CU48mf0d2Q8J2CxQo6ys8qzgFRL6KKqLXDDS0u1yDEwXPTOMjY6ucbu
 d8lhbLBkU3LA2SF8YZUzAIfi8/ht/8iOY909On8QsQqJPyOLQOuU3B5e0q30Cs6oikX4
 L/IU9iPoHC2yZAKTGrx5bTuudHcR2C4axDo7zxqy9hPaHi6BgAzNRJvlo1z78OCnIa4d cA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb47r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:59 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id F1A773F7044;
        Fri, 24 Apr 2020 00:27:57 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 08/17] net: atlantic: A2 driver-firmware interface
Date:   Fri, 24 Apr 2020 10:27:20 +0300
Message-ID: <20200424072729.953-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the driver<->firmware interface for A2

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h | 531 ++++++++++++++++++
 1 file changed, 531 insertions(+)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
new file mode 100644
index 000000000000..90a1e7c723b1
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -0,0 +1,531 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef HW_ATL2_UTILS_H
+#define HW_ATL2_UTILS_H
+
+/* Start of HW byte packed interface declaration */
+#pragma pack(push, 1)
+
+/* F W    A P I */
+
+struct link_options_s {
+	u32 link_up:1;
+	u32 link_renegotiate:1;
+	u32 minimal_link_speed:1;
+	u32 internal_loopback:1;
+	u32 external_loopback:1;
+
+	u32 rate_10M_hd:1;
+	u32 rate_100M_hd:1;
+	u32 rate_1G_hd:1;
+
+	u32 rate_10M:1;
+	u32 rate_100M:1;
+	u32 rate_1G:1;
+	u32 rate_2P5G:1;
+	u32 rate_N2P5G:1;
+	u32 rate_5G:1;
+	u32 rate_N5G:1;
+	u32 rate_10G:1;
+
+	u32 eee_100M:1;
+	u32 eee_1G:1;
+	u32 eee_2P5G:1;
+	u32 eee_5G:1;
+	u32 eee_10G:1;
+	u32 rsvd3:3;
+
+	u32 pause_rx:1;
+	u32 pause_tx:1;
+	u32 rsvd4:1;
+	u32 downshift:1;
+	u32 downshift_retry:4;
+};
+
+struct link_control_s {
+	u32 mode:4;
+
+	u32 disable_crc_corruption:1;
+	u32 discard_short_frames:1;
+	u32 flow_control_mode:1;
+	u32 disable_length_check:1;
+	u32 discard_errored_frames:1;
+	u32 control_frame_enable:1;
+	u32 enable_tx_padding:1;
+	u32 enable_crc_forwarding:1;
+	u32 enable_frame_padding_removal_rx: 1;
+	u32 promiscuous_mode: 1;
+	u32 rsvd:18;
+};
+
+struct thermal_shutdown_s {
+	u32 enable:1;
+	u32 warning_enable:1;
+	u32 rsvd:6;
+
+	u32 cold_temperature:8;
+	u32 warning_temperature:8;
+	u32 shutdown_temperature:8;
+};
+
+struct mac_address_s {
+	u8 mac_address[6];
+	u16 rsvd;
+};
+
+struct sleep_proxy_s {
+	struct wake_on_lan_s {
+		u32 wake_on_magic_packet:1;
+		u32 wake_on_pattern:1;
+		u32 wake_on_link_up:1;
+		u32 wake_on_link_down:1;
+		u32 wake_on_ping:1;
+		u32 wake_on_timer:1;
+		u32 rsvd:26;
+
+		u32 link_up_timeout;
+		u32 link_down_timeout;
+		u32 timer;
+
+		struct {
+			u32 mask[4];
+			u32 crc32;
+		} wake_up_patterns[8];
+	} wake_on_lan;
+
+	struct {
+		u32 arp_responder:1;
+		u32 echo_responder:1;
+		u32 igmp_client:1;
+		u32 echo_truncate:1;
+		u32 address_guard:1;
+		u32 ignore_fragmented:1;
+		u32 rsvd:2;
+		u32 echo_max_len:16;
+		u32 ipv4[8];
+		u32 reserved[8];
+	} ipv4_offload;
+
+	struct {
+		u32 ns_responder:1;
+		u32 echo_responder:1;
+		u32 mld_client:1;
+		u32 echo_truncate:1;
+		u32 address_guard:1;
+		u32 rsvd:3;
+		u32 echo_max_len:16;
+		u32 ipv6[16][4];
+	} ipv6_offload;
+
+	struct {
+		u16 ports[16];
+	} tcp_port_offload;
+
+	struct {
+		u16 ports[16];
+	} udp_port_offload;
+
+	struct ka4_offloads_s {
+		u32 retry_count;
+		u32 retry_interval;
+
+		struct ka4_offload_s {
+			u32 timeout;
+			u16 local_port;
+			u16 remote_port;
+			u8 remote_mac_addr[6];
+			u32 rsvd:16;
+			u32 rsvd2:32;
+			u32 rsvd3:32;
+			u32 rsvd4:16;
+			u16 win_size;
+			u32 seq_num;
+			u32 ack_num;
+			u32 local_ip;
+			u32 remote_ip;
+		} offloads[16];
+	} ka4_offload;
+
+	struct ka6_offloads_s {
+		u32 retry_count;
+		u32 retry_interval;
+
+		struct ka6_offload_s {
+			u32 timeout;
+			u16 local_port;
+			u16 remote_port;
+			u8 remote_mac_addr[6];
+			u32 rsvd:16;
+			u32 rsvd2:32;
+			u32 rsvd3:32;
+			u32 rsvd4:16;
+			u16 win_size;
+			u32 seq_num;
+			u32 ack_num;
+			u32 local_ip[4];
+			u32 remote_ip[4];
+		} offloads[16];
+	} ka6_offload;
+
+	struct {
+		u32 rr_count;
+		u32 rr_buf_len;
+		u32 idx_offset;
+		u32 rr__offset;
+	} mdns;
+	u32 reserve_fw_gap:16;
+};
+
+struct pause_quanta_s {
+	u16 quanta_10M;
+	u16 threshold_10M;
+	u16 quanta_100M;
+	u16 threshold_100M;
+	u16 quanta_1G;
+	u16 threshold_1G;
+	u16 quanta_2P5G;
+	u16 threshold_2P5G;
+	u16 quanta_5G;
+	u16 threshold_5G;
+	u16 quanta_10G;
+	u16 threshold_10G;
+};
+
+struct data_buffer_status_s {
+	u32 data_offset;
+	u32 data_length;
+};
+
+struct device_caps_s {
+	u32 finite_flashless:1;
+	u32 cable_diag:1;
+	u32 ncsi:1;
+	u32 avb:1;
+	u32:28;
+	u32:32;
+};
+
+struct version_s {
+	struct bundle_version_t {
+		u32 major:8;
+		u32 minor:8;
+		u32 build:16;
+	} bundle;
+	struct mac_version_t {
+		u32 major:8;
+		u32 minor:8;
+		u32 build:16;
+	} mac;
+	struct phy_version_t {
+		u32 major:8;
+		u32 minor:8;
+		u32 build:16;
+	} phy;
+	u32 rsvd:32;
+};
+
+struct link_status_s {
+	u32 link_state:4;
+	u32 link_rate:4;
+
+	u32 pause_tx:1;
+	u32 pause_rx:1;
+	u32 eee:1;
+	u32 duplex:1;
+	u32 rsvd:4;
+
+	u32 rsvd2:16;
+};
+
+struct wol_status_s {
+	u32 wake_count:8;
+	u32 wake_reason:8;
+	u32 wake_up_packet_length :12;
+	u32 wake_up_pattern_number :3;
+	u32 rsvd:1;
+	u32 wake_up_packet[379];
+};
+
+struct mac_health_monitor_s {
+	u32 mac_ready:1;
+	u32 mac_fault:1;
+	u32 mac_flashless_finished:1;
+	u32 rsvd:5;
+	u32 mac_temperature:8;
+	u32 mac_heart_beat:16;
+	u32 mac_fault_code:16;
+	u32 rsvd2:16;
+};
+
+struct phy_health_monitor_s {
+	u32 phy_ready:1;
+	u32 phy_fault:1;
+	u32 phy_hot_warning:1;
+	u32 rsvd:5;
+	u32 phy_temperature:8;
+	u32 phy_heart_beat:16;
+	u32 phy_fault_code:16;
+	u32 rsvd2:16;
+};
+
+struct device_link_caps_s {
+	u32 rsvd:3;
+	u32 internal_loopback:1;
+	u32 external_loopback:1;
+
+	u32 rate_10M_hd:1;
+	u32 rate_100M_hd:1;
+	u32 rate_1G_hd:1;
+
+	u32 rate_10M:1;
+	u32 rate_100M:1;
+	u32 rate_1G:1;
+	u32 rate_2P5G:1;
+	u32 rate_N2P5G:1;
+	u32 rate_5G:1;
+	u32 rate_N5G:1;
+	u32 rate_10G:1;
+
+	u32 rsvd3:1;
+	u32 eee_100M:1;
+	u32 eee_1G:1;
+	u32 eee_2P5G:1;
+	u32 rsvd4:1;
+	u32 eee_5G:1;
+	u32 rsvd5:1;
+	u32 eee_10G:1;
+
+	u32 pause_rx:1;
+	u32 pause_tx:1;
+	u32 pfc:1;
+	u32 downshift:1;
+	u32 downshift_retry:4;
+};
+
+struct sleep_proxy_caps_s {
+	u32 ipv4_offload:1;
+	u32 ipv6_offload:1;
+	u32 tcp_port_offload:1;
+	u32 udp_port_offload:1;
+	u32 ka4_offload:1;
+	u32 ka6_offload:1;
+	u32 mdns_offload:1;
+	u32 wake_on_ping:1;
+
+	u32 wake_on_magic_packet:1;
+	u32 wake_on_pattern:1;
+	u32 wake_on_timer:1;
+	u32 wake_on_link:1;
+	u32 wake_patterns_count:4;
+
+	u32 ipv4_count:8;
+	u32 ipv6_count:8;
+
+	u32 tcp_port_offload_count:8;
+	u32 udp_port_offload_count:8;
+
+	u32 tcp4_ka_count:8;
+	u32 tcp6_ka_count:8;
+
+	u32 igmp_offload:1;
+	u32 mld_offload:1;
+	u32 rsvd:30;
+};
+
+struct lkp_link_caps_s {
+	u32 rsvd:5;
+
+	u32 rate_10M_hd:1;
+	u32 rate_100M_hd:1;
+	u32 rate_1G_hd:1;
+
+	u32 rate_10M:1;
+	u32 rate_100M:1;
+	u32 rate_1G:1;
+	u32 rate_2P5G:1;
+	u32 rate_N2P5G:1;
+	u32 rate_5G:1;
+	u32 rate_N5G:1;
+	u32 rate_10G:1;
+
+	u32 rsvd2:1;
+	u32 eee_100M:1;
+	u32 eee_1G:1;
+	u32 eee_2P5G:1;
+	u32 rsvd3:1;
+	u32 eee_5G:1;
+	u32 rsvd4:1;
+	u32 eee_10G:1;
+
+	u32 pause_rx:1;
+	u32 pause_tx:1;
+	u32 rsvd5:6;
+};
+
+struct core_dump_s {
+	u32 reg0;
+	u32 reg1;
+	u32 reg2;
+
+	u32 hi;
+	u32 lo;
+
+	u32 regs[32];
+};
+
+struct trace_s {
+	u32 sync_counter;
+	u32 mem_buffer[0x1ff];
+};
+
+struct cable_diag_control_s {
+	u32 toggle :1;
+	u32 rsvd:7;
+	u32 wait_timeout_sec:8;
+	u32 rsvd2:16;
+};
+
+struct cable_diag_lane_data_s {
+	u32 result_code :8;
+	u32 dist :8;
+	u32 far_dist :8;
+	u32 rsvd:8;
+};
+
+struct cable_diag_status_s {
+	struct cable_diag_lane_data_s lane_data[4];
+	u32 transact_id:8;
+	u32 status:4;
+	u32 rsvd:20;
+};
+
+struct statistics_s {
+	struct {
+		u32 link_up;
+		u32 link_down;
+	} link;
+
+	struct {
+		u64 tx_unicast_octets;
+		u64 tx_multicast_octets;
+		u64 tx_broadcast_octets;
+		u64 rx_unicast_octets;
+		u64 rx_multicast_octets;
+		u64 rx_broadcast_octets;
+
+		u32 tx_unicast_frames;
+		u32 tx_multicast_frames;
+		u32 tx_broadcast_frames;
+		u32 tx_errors;
+
+		u32 rx_unicast_frames;
+		u32 rx_multicast_frames;
+		u32 rx_broadcast_frames;
+		u32 rx_dropped_frames;
+		u32 rx_error_frames;
+
+		u32 tx_good_frames;
+		u32 rx_good_frames;
+		u32 reserve_fw_gap;
+	} msm;
+	u32 main_loop_cycles;
+};
+
+struct filter_caps_s {
+	u8 l2_filters_base_index:6;
+	u8 flexible_filter_mask:2;
+	u8 l2_filter_count;
+	u8 ethertype_filter_base_index;
+	u8 ethertype_filter_count;
+
+	u8 vlan_filter_base_index;
+	u8 vlan_filter_count;
+	u8 l3_ip4_filter_base_index:4;
+	u8 l3_ip4_filter_count:4;
+	u8 l3_ip6_filter_base_index:4;
+	u8 l3_ip6_filter_count:4;
+
+	u8 l4_filter_base_index:4;
+	u8 l4_filter_count:4;
+	u8 l4_flex_filter_base_index:4;
+	u8 l4_flex_filter_count:4;
+	u8 rslv_tbl_base_index;
+	u8 rslv_tbl_count;
+};
+
+struct fw_interface_in {
+	u32 mtu;
+	u32 rsvd1:32;
+	struct mac_address_s mac_address;
+	struct link_control_s link_control;
+	u32 rsvd2:32;
+	struct link_options_s link_options;
+	u32 rsvd3:32;
+	struct thermal_shutdown_s thermal_shutdown;
+	u32 rsvd4:32;
+	struct sleep_proxy_s sleep_proxy;
+	u32 rsvd5:32;
+	struct pause_quanta_s pause_quanta[8];
+	struct cable_diag_control_s cable_diag_control;
+	u32 rsvd6:32;
+	struct data_buffer_status_s data_buffer_status;
+};
+
+struct transaction_counter_s {
+	u32 transaction_cnt_a:16;
+	u32 transaction_cnt_b:16;
+};
+
+struct fw_interface_out {
+	struct transaction_counter_s transaction_id;
+	struct version_s version;
+	struct link_status_s link_status;
+	struct wol_status_s wol_status;
+	u32 rsvd:32;
+	u32 rsvd2:32;
+	struct mac_health_monitor_s mac_health_monitor;
+	u32 rsvd3:32;
+	u32 rsvd4:32;
+	struct phy_health_monitor_s phy_health_monitor;
+	u32 rsvd5:32;
+	u32 rsvd6:32;
+	struct cable_diag_status_s cable_diag_status;
+	u32 rsvd7:32;
+	struct device_link_caps_s device_link_caps;
+	u32 rsvd8:32;
+	struct sleep_proxy_caps_s sleep_proxy_caps;
+	u32 rsvd9:32;
+	struct lkp_link_caps_s lkp_link_caps;
+	u32 rsvd10:32;
+	struct core_dump_s core_dump;
+	u32 rsvd11:32;
+	struct statistics_s stats;
+	u32 rsvd12:32;
+	u32 rsvd13:32;
+	struct filter_caps_s filter_caps;
+	struct device_caps_s device_caps;
+	u32 reserve[30];
+	struct trace_s trace;
+};
+
+/* End of HW byte packed interface declaration */
+#pragma pack(pop)
+
+#define  AQ_A2_FW_LINK_RATE_INVALID 0
+#define  AQ_A2_FW_LINK_RATE_10M     1
+#define  AQ_A2_FW_LINK_RATE_100M    2
+#define  AQ_A2_FW_LINK_RATE_1G      3
+#define  AQ_A2_FW_LINK_RATE_2G5     4
+#define  AQ_A2_FW_LINK_RATE_5G      5
+#define  AQ_A2_FW_LINK_RATE_10G     6
+
+#define  AQ_HOST_MODE_INVALID      0U
+#define  AQ_HOST_MODE_ACTIVE       1U
+#define  AQ_HOST_MODE_SLEEP_PROXY  2U
+#define  AQ_HOST_MODE_LOW_POWER    3U
+#define  AQ_HOST_MODE_SHUTDOWN     4U
+
+#endif /* HW_ATL2_UTILS_H */
-- 
2.17.1

