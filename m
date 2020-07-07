Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72821784D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgGGTwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:52:01 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:54006 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGTwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1594151509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l4me6/ClA0si1iVDmku9LMiqlZevCbifVxMtlLSGSeQ=;
        b=A/Lh9TDINi+BmFt0ZwT6oMsG0gzyHYcAD+1IBdLp+0zhCQyGTgsarI4LqQaJA5Yw+wri26
        Uv+V1Ken3EcqobmLwRijVJvcNgG2DeXAbySix/D433krN8IhrDW2xdpwYELjUBk6C2LLqQ
        CmZ7gfhE/1ijYoXnFNr4FfAFAN16auw=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+2eeeb5ad0766b57394d8@syzkaller.appspotmail.com>,
        kuba@kernel.org
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in batadv_iv_ogm_schedule_buff (2)
Date:   Tue, 07 Jul 2020 21:51:36 +0200
Message-ID: <4690983.koCjOrnfvf@sven-edge>
In-Reply-To: <000000000000f06edf05a9dbaa44@google.com>
References: <000000000000f06edf05a9dbaa44@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2573515.iUh7y9OTu9"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2573515.iUh7y9OTu9
Content-Type: multipart/mixed; boundary="nextPart3617159.Z5ivtThzXN"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart3617159.Z5ivtThzXN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, 7 July 2020 17:30:14 CEST syzbot wrote:
> general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> CPU: 1 PID: 9126 Comm: kworker/u4:9 Not tainted 5.8.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
> RIP: 0010:batadv_iv_ogm_schedule_buff+0xd1e/0x1410 net/batman-adv/bat_iv_ogm.c:843

Seems to be following lines:

 838         /* OGMs from primary interfaces are scheduled on all
 839          * interfaces.
 840          */
 841         rcu_read_lock();
 842         list_for_each_entry_rcu(tmp_hard_iface, &batadv_hardif_list, list) {
 843                 if (tmp_hard_iface->soft_iface != hard_iface->soft_iface)
 844                         continue;

If I understand it correctly, the tmp_hard_iface is NULL and then accessing 
soft_iface (offset 0x70 on amd64) causes this problem. But neither the 
batadv_hardif_list should ever point to NULL nor any entry inside the list.

I've just went through all code which accesses the list:

* bat_iv_ogm.c 839,7 @@ static void batadv_iv_ogm_schedule_buff
* bat_iv_ogm.c 1606,7 @@ static void batadv_iv_ogm_process
* bat_iv_ogm.c 1671,7 @@ static void batadv_iv_ogm_process
* bat_iv_ogm.c 2144,7 @@ static void batadv_iv_neigh_print
* bat_iv_ogm.c 2313,8 @@ batadv_iv_ogm_neigh_dump
* bat_v.c 188,7 @@ static void batadv_v_neigh_print
* bat_v.c 315,7 @@ batadv_v_neigh_dump
* bat_v_elp.c 425,7 @@ void batadv_v_elp_primary_iface_set
* bat_v_ogm.c 298,7 @@ static void batadv_v_ogm_send_softif
* bat_v_ogm.c 923,7 @@ static void batadv_v_ogm_process
* hard-interface.c 68,7 @@ batadv_hardif_get_by_netdev
* hard-interface.c 431,7 @@ batadv_hardif_get_active
* hard-interface.c 501,7 @@ static void batadv_check_known_mac_addr
* hard-interface.c 533,7 @@ static void batadv_hardif_recalc_extra_skbroom
* hard-interface.c 572,7 @@ int batadv_hardif_min_mtu
* hard-interface.c 829,7 @@ static size_t batadv_hardif_cnt
* main.c 290,7 @@ bool batadv_is_my_mac
* netlink.c 991,7 @@ batadv_netlink_dump_hardif
* originator.c 1301,7 @@ static bool batadv_purge_orig_node
* send.c 882,7 @@ static void batadv_send_outstanding_bcast_packet
* soft-interface.c 1141,7 @@ static void batadv_softif_destroy_netlink



and all the code which adds to the list or initializes parts of the list:

* hard-interface.c 927,7 @@ batadv_hardif_add_interface

  - should be under rtnl_lock

* hard-interface.c 945,7 @@ batadv_hardif_add_interface

  - should be under rtnl_lock

* hard-interface.c 99,7 @@ static int __init batadv_init

  - this is done to initialized the list head before the rest of the code is 
    initialized


and all the code which removes entries from the list:

* hard-interface.c 985,8 @@ void batadv_hardif_remove_interfaces

  - is under rtnl_lock
  - there should also be nothing in this list because unregister_netdevice_notifier
    will trigger a NETDEV_UNREGISTER of these devices

* hard-interface.c 1048,7 @@ static int batadv_hard_if_event

  - should be under rtnl_lock



The batadv_hard_iface is only kfree_rcu'ed by batadv_hardif_release when the 
reference counter is zero. The reference counter is increased in:

* bat_iv_ogm.c 843,20 @@ static void batadv_iv_ogm_schedule_buff
* bat_iv_ogm.c 1678,13 @@ static void batadv_iv_ogm_process
* bat_v_ogm.c 302,7 @@ static void batadv_v_ogm_send_softif
* bat_v_ogm.c 930,7 @@ static void batadv_v_ogm_process
* hard-interface.c 70,7 @@ batadv_hardif_get_by_netdev
* hard-interface.c 436,7 @@ batadv_hardif_get_active
* hard-interface.c 471,7 @@ static void batadv_primary_if_select
* hard-interface.c 720,7 @@ int batadv_hardif_enable_interface
* hard-interface.c 765,7 @@ int batadv_hardif_enable_interface
* hard-interface.c 932,7 @@ batadv_hardif_add_interface
* hard-interface.c 944,7 @@ batadv_hardif_add_interface
* hard-interface.h 133,7 @@ batadv_primary_if_get_selected
* main.c 460,7 @@ int batadv_batman_skb_recv
* originator.c 413,7 @@ batadv_orig_ifinfo_new
* originator.c 491,7 @@ batadv_neigh_ifinfo_new
* originator.c 570,7 @@ batadv_hardif_neigh_create
* originator.c 682,7 @@ batadv_neigh_node_create
* originator.c 1308,7 @@ static bool batadv_purge_orig_node
* send.c 527,10 @@ batadv_forw_packet_alloc
* send.c 932,7 @@ static void batadv_send_outstanding_bcast_packet


and decreased:

* bat_iv_ogm.c 518,7 @@ batadv_iv_ogm_can_aggregate
* bat_iv_ogm.c 843,20 @@ static void batadv_iv_ogm_schedule_buff
* bat_iv_ogm.c 1678,13 @@ static void batadv_iv_ogm_process
* bat_v.c 51,7 @@ static void batadv_v_iface_activate
* bat_v.c 108,7 @@ static void batadv_v_iface_update_mac
* bat_v_elp.c 540,7 @@ int batadv_v_elp_packet_recv
* bat_v_ogm.c 326,7 @@ static void batadv_v_ogm_send_softif
* bat_v_ogm.c 340,12 @@ static void batadv_v_ogm_send_softif
* bat_v_ogm.c 958,7 @@ static void batadv_v_ogm_process
* bat_v_ogm.c 966,7 @@ static void batadv_v_ogm_process
* bridge_loop_avoidance.c 440,7 @@ static void batadv_bla_send_claim
* bridge_loop_avoidance.c 1405,7 @@ void batadv_bla_status_update
* bridge_loop_avoidance.c 1499,7 @@ static void batadv_bla_periodic_work
* bridge_loop_avoidance.c 1538,7 @@ int batadv_bla_init
* bridge_loop_avoidance.c 1746,7 @@ void batadv_bla_free
* bridge_loop_avoidance.c 1910,7 @@ bool batadv_bla_rx
* bridge_loop_avoidance.c 2017,7 @@ bool batadv_bla_tx
* bridge_loop_avoidance.c 2081,7 @@ int batadv_bla_claim_table_seq_print_text
* bridge_loop_avoidance.c 2248,7 @@ int batadv_bla_claim_dump
* bridge_loop_avoidance.c 2317,7 @@ int batadv_bla_backbone_table_seq_print_text
* bridge_loop_avoidance.c 2486,7 @@ int batadv_bla_backbone_dump
* bridge_loop_avoidance.c 2538,7 @@ bool batadv_bla_check_claim
* distributed-arp-table.c 891,7 @@ int batadv_dat_cache_seq_print_text
* distributed-arp-table.c 1037,7 @@ int batadv_dat_cache_dump
* fragmentation.c 540,7 @@ int batadv_frag_send_packet
* gateway_client.c 535,7 @@ int batadv_gw_client_seq_print_text
* gateway_client.c 595,7 @@ int batadv_gw_dump
* hard-interface.c 239,7 @@ static struct net_device *batadv_get_real_netdevice
* hard-interface.c 460,7 @@ static void batadv_primary_if_update_addr
* hard-interface.c 484,7 @@ static void batadv_primary_if_select
* hard-interface.c 657,7 @@ batadv_hardif_activate_interface
* hard-interface.c 809,7 @@ int batadv_hardif_enable_interface
* hard-interface.c 860,7 @@ void batadv_hardif_disable_interface
* hard-interface.c 870,7 @@ void batadv_hardif_disable_interface
* hard-interface.c 893,11 @@ void batadv_hardif_disable_interface
* hard-interface.c 973,7 @@ static void batadv_hardif_remove_interface
* hard-interface.c 1086,10 @@ static int batadv_hard_if_event
* icmp_socket.c 278,7 @@ static ssize_t batadv_socket_write
* main.c 336,7 @@ batadv_seq_print_text_primary_if_get
* main.c 504,7 @@ int batadv_batman_skb_recv
* main.c 515,7 @@ int batadv_batman_skb_recv
* multicast.c 2152,7 @@ int batadv_mcast_flags_seq_print_text
* multicast.c 2361,7 @@ batadv_mcast_netlink_get_primary
* multicast.c 2389,7 @@ int batadv_mcast_flags_dump
* netlink.c 359,14 @@ static int batadv_netlink_mesh_fill
* netlink.c 1217,7 @@ batadv_get_hardif_from_info
* netlink.c 1336,7 @@ static void batadv_post_doit
* network-coding.c 1937,7 @@ int batadv_nc_nodes_seq_print_text
* originator.c 239,7 @@ static void batadv_neigh_ifinfo_release
* originator.c 270,7 @@ static void batadv_hardif_neigh_release
* originator.c 304,7 @@ static void batadv_neigh_node_release
* originator.c 756,7 @@ int batadv_hardif_neigh_seq_print_text
* originator.c 835,11 @@ int batadv_hardif_neigh_dump
* originator.c 859,7 @@ static void batadv_orig_ifinfo_release
* originator.c 1319,7 @@ static bool batadv_purge_orig_node
* originator.c 1406,7 @@ int batadv_orig_seq_print_text
* originator.c 1461,7 @@ int batadv_orig_hardif_seq_print_text
* originator.c 1532,11 @@ int batadv_orig_dump
* routing.c 280,7 @@ static int batadv_recv_my_icmp_packet
* routing.c 335,7 @@ static int batadv_recv_icmp_ttl_exceeded
* routing.c 796,7 @@ batadv_reroute_unicast_packet
* routing.c 907,7 @@ static bool batadv_check_unicast_ttvn
* send.c 310,7 @@ bool batadv_send_skb_prepare_unicast_4addr
* send.c 475,9 @@ void batadv_forw_packet_free
* send.c 767,14 @@ int batadv_add_bcast_packet_to_list
* send.c 932,7 @@ static void batadv_send_outstanding_bcast_packet
* soft-interface.c 395,7 @@ static netdev_tx_t batadv_interface_tx
* soft-interface.c 893,7 @@ static int batadv_softif_slave_add
* soft-interface.c 920,7 @@ static int batadv_softif_slave_del
* sysfs.c 282,7 @@ ssize_t batadv_store_##_name
* sysfs.c 301,7 @@ ssize_t batadv_show_##_name
* sysfs.c 959,7 @@ static ssize_t batadv_show_mesh_iface
* sysfs.c 1013,7 @@ static int batadv_store_mesh_iface_finish
* sysfs.c 1110,7 @@ static ssize_t batadv_show_iface_status
* sysfs.c 1170,7 @@ static ssize_t batadv_store_throughput_override
* sysfs.c 1190,7 @@ static ssize_t batadv_show_throughput_override
* tp_meter.c 748,7 @@ static void batadv_tp_recv_ack
* tp_meter.c 882,7 @@ static int batadv_tp_send
* tp_meter.c 1207,7 @@ static int batadv_tp_send_ack
* translation-table.c 820,7 @@ bool batadv_tt_local_add
* translation-table.c 1135,7 @@ int batadv_tt_local_seq_print_text
* translation-table.c 1293,7 @@ int batadv_tt_local_dump
* translation-table.c 2007,7 @@ int batadv_tt_global_seq_print_text
* translation-table.c 2214,7 @@ int batadv_tt_global_dump
* translation-table.c 3198,7 @@ static bool batadv_send_tt_request
* translation-table.c 3461,7 @@ static bool batadv_send_my_tt_response
* translation-table.c 3785,7 @@ static void batadv_send_roam_adv


Btw. we can most likely ignore everything related to bat_v* because it crashed 
in bat_iv. So if anybody else spots something which I've missed....

Kind regards,
	Sven
--nextPart3617159.Z5ivtThzXN
Content-Disposition: attachment; filename="refcnt-hardif.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="refcnt-hardif.diff"

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index a4faf5f9..c9462f5f 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -518,7 +518,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return res;
 }
 
@@ -843,20 +843,20 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 		if (tmp_hard_iface->soft_iface != hard_iface->soft_iface)
 			continue;
 
-		if (!kref_get_unless_zero(&tmp_hard_iface->refcount))
+		if (!kref_get_unless_zero(&tmp_hard_iface->refcount))
 			continue;
 
 		batadv_iv_ogm_queue_add(bat_priv, *ogm_buff,
 					*ogm_buff_len, hard_iface,
 					tmp_hard_iface, 1, send_time);
 
-		batadv_hardif_put(tmp_hard_iface);
+		batadv_hardif_put(tmp_hard_iface);
 	}
 	rcu_read_unlock();
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
@@ -1678,13 +1678,13 @@ static void batadv_iv_ogm_process(const struct sk_buff *skb, int ogm_offset,
 		if (hard_iface->soft_iface != bat_priv->soft_iface)
 			continue;
 
-		if (!kref_get_unless_zero(&hard_iface->refcount))
+		if (!kref_get_unless_zero(&hard_iface->refcount))
 			continue;
 
 		batadv_iv_ogm_process_per_outif(skb, ogm_offset, orig_node,
 						if_incoming, hard_iface);
 
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 	rcu_read_unlock();
 
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 0ecaf1bb..8575e975 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -51,7 +51,7 @@ static void batadv_v_iface_activate(struct batadv_hard_iface *hard_iface)
 
 	if (primary_if) {
 		batadv_v_elp_iface_activate(primary_if, hard_iface);
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	}
 
 	/* B.A.T.M.A.N. V does not use any queuing mechanism, therefore it can
@@ -108,7 +108,7 @@ static void batadv_v_iface_update_mac(struct batadv_hard_iface *hard_iface)
 	batadv_v_primary_iface_set(hard_iface);
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static void
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index d35aca0e..31415432 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -540,7 +540,7 @@ int batadv_v_elp_packet_recv(struct sk_buff *skb,
 				  elp_packet);
 
 	ret = NET_RX_SUCCESS;
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 free_skb:
 	if (ret == NET_RX_SUCCESS)
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 0f8495b9..28ace1f5 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -302,7 +302,7 @@ static void batadv_v_ogm_send_softif(struct batadv_priv *bat_priv)
 		if (hard_iface->soft_iface != bat_priv->soft_iface)
 			continue;
 
-		if (!kref_get_unless_zero(&hard_iface->refcount))
+		if (!kref_get_unless_zero(&hard_iface->refcount))
 			continue;
 
 		ret = batadv_hardif_no_broadcast(hard_iface, NULL, NULL);
@@ -326,7 +326,7 @@ static void batadv_v_ogm_send_softif(struct batadv_priv *bat_priv)
 			batadv_dbg(BATADV_DBG_BATMAN, bat_priv, "OGM2 from ourselves on %s suppressed: %s\n",
 				   hard_iface->net_dev->name, type);
 
-			batadv_hardif_put(hard_iface);
+			batadv_hardif_put(hard_iface);
 			continue;
 		}
 
@@ -340,12 +340,12 @@ static void batadv_v_ogm_send_softif(struct batadv_priv *bat_priv)
 		/* this skb gets consumed by batadv_v_ogm_send_to_if() */
 		skb_tmp = skb_clone(skb, GFP_ATOMIC);
 		if (!skb_tmp) {
-			batadv_hardif_put(hard_iface);
+			batadv_hardif_put(hard_iface);
 			break;
 		}
 
 		batadv_v_ogm_queue_on_if(skb_tmp, hard_iface);
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 	rcu_read_unlock();
 
@@ -930,7 +930,7 @@ static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 		if (hard_iface->soft_iface != bat_priv->soft_iface)
 			continue;
 
-		if (!kref_get_unless_zero(&hard_iface->refcount))
+		if (!kref_get_unless_zero(&hard_iface->refcount))
 			continue;
 
 		ret = batadv_hardif_no_broadcast(hard_iface,
@@ -958,7 +958,7 @@ static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 				   ogm_packet->orig, hard_iface->net_dev->name,
 				   type);
 
-			batadv_hardif_put(hard_iface);
+			batadv_hardif_put(hard_iface);
 			continue;
 		}
 
@@ -966,7 +966,7 @@ static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 					       orig_node, neigh_node,
 					       if_incoming, hard_iface);
 
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 	rcu_read_unlock();
 out:
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 91a04ca3..a7c6fd75 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -440,7 +440,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	netif_rx(skb);
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 /**
@@ -1405,7 +1405,7 @@ void batadv_bla_status_update(struct net_device *net_dev)
 	 * so just call that one.
 	 */
 	batadv_bla_update_orig_address(bat_priv, primary_if, primary_if);
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 /**
@@ -1499,7 +1499,7 @@ static void batadv_bla_periodic_work(struct work_struct *work)
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	queue_delayed_work(batadv_event_workqueue, &bat_priv->bla.work,
 			   msecs_to_jiffies(BATADV_BLA_PERIOD_LENGTH));
@@ -1538,7 +1538,7 @@ int batadv_bla_init(struct batadv_priv *bat_priv)
 	if (primary_if) {
 		crc = crc16(0, primary_if->net_dev->dev_addr, ETH_ALEN);
 		bat_priv->bla.claim_dest.group = htons(crc);
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	} else {
 		bat_priv->bla.claim_dest.group = 0; /* will be set later */
 	}
@@ -1746,7 +1746,7 @@ void batadv_bla_free(struct batadv_priv *bat_priv)
 		bat_priv->bla.backbone_hash = NULL;
 	}
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 /**
@@ -1910,7 +1910,7 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (claim)
 		batadv_claim_put(claim);
 	return ret;
@@ -2017,7 +2017,7 @@ bool batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	ret = true;
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (claim)
 		batadv_claim_put(claim);
 	return ret;
@@ -2081,7 +2081,7 @@ int batadv_bla_claim_table_seq_print_text(struct seq_file *seq, void *offset)
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 #endif
@@ -2248,7 +2248,7 @@ int batadv_bla_claim_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	if (soft_iface)
 		dev_put(soft_iface);
@@ -2317,7 +2317,7 @@ int batadv_bla_backbone_table_seq_print_text(struct seq_file *seq, void *offset)
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 #endif
@@ -2486,7 +2486,7 @@ int batadv_bla_backbone_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	if (soft_iface)
 		dev_put(soft_iface);
@@ -2538,7 +2538,7 @@ bool batadv_bla_check_claim(struct batadv_priv *bat_priv,
 		batadv_claim_put(claim);
 	}
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	return ret;
 }
 #endif
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 0e6e53e9..764996c3 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -891,7 +891,7 @@ int batadv_dat_cache_seq_print_text(struct seq_file *seq, void *offset)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 #endif
@@ -1037,7 +1037,7 @@ int batadv_dat_cache_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	if (soft_iface)
 		dev_put(soft_iface);
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 9fdbe306..c55de05f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -540,7 +540,7 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 	skb = NULL;
 
 put_primary_if:
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 free_skb:
 	kfree_skb(skb);
 
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index a18dcc68..d921d210 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -535,7 +535,7 @@ int batadv_gw_client_seq_print_text(struct seq_file *seq, void *offset)
 		   primary_if->net_dev->dev_addr, net_dev->name,
 		   bat_priv->algo_ops->name);
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	if (!bat_priv->algo_ops->gw.print) {
 		seq_puts(seq,
@@ -595,7 +595,7 @@ int batadv_gw_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (soft_iface)
 		dev_put(soft_iface);
 
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index fa06b51c..b7360b3b 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -50,7 +50,7 @@ void batadv_hardif_release(struct kref *ref)
 {
 	struct batadv_hard_iface *hard_iface;
 
-	hard_iface = container_of(ref, struct batadv_hard_iface, refcount);
+	hard_iface = container_of(ref, struct batadv_hard_iface, refcount);
 	dev_put(hard_iface->net_dev);
 
 	kfree_rcu(hard_iface, rcu);
@@ -70,7 +70,7 @@ batadv_hardif_get_by_netdev(const struct net_device *net_dev)
 	rcu_read_lock();
 	list_for_each_entry_rcu(hard_iface, &batadv_hardif_list, list) {
 		if (hard_iface->net_dev == net_dev &&
-		    kref_get_unless_zero(&hard_iface->refcount))
+		    kref_get_unless_zero(&hard_iface->refcount))
 			goto out;
 	}
 
@@ -239,7 +239,7 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 
 out:
 	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	return real_netdev;
 }
 
@@ -436,7 +436,7 @@ batadv_hardif_get_active(const struct net_device *soft_iface)
 			continue;
 
 		if (hard_iface->if_status == BATADV_IF_ACTIVE &&
-		    kref_get_unless_zero(&hard_iface->refcount))
+		    kref_get_unless_zero(&hard_iface->refcount))
 			goto out;
 	}
 
@@ -460,7 +460,7 @@ static void batadv_primary_if_update_addr(struct batadv_priv *bat_priv,
 	batadv_bla_update_orig_address(bat_priv, primary_if, oldif);
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static void batadv_primary_if_select(struct batadv_priv *bat_priv,
@@ -471,7 +471,7 @@ static void batadv_primary_if_select(struct batadv_priv *bat_priv,
 	ASSERT_RTNL();
 
 	if (new_hard_iface)
-		kref_get(&new_hard_iface->refcount);
+		kref_get(&new_hard_iface->refcount);
 
 	curr_hard_iface = rcu_replace_pointer(bat_priv->primary_if,
 					      new_hard_iface, 1);
@@ -484,7 +484,7 @@ static void batadv_primary_if_select(struct batadv_priv *bat_priv,
 
 out:
 	if (curr_hard_iface)
-		batadv_hardif_put(curr_hard_iface);
+		batadv_hardif_put(curr_hard_iface);
 }
 
 static bool
@@ -657,7 +657,7 @@ batadv_hardif_activate_interface(struct batadv_hard_iface *hard_iface)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static void
@@ -720,7 +720,7 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	if (hard_iface->if_status != BATADV_IF_NOT_IN_USE)
 		goto out;
 
-	kref_get(&hard_iface->refcount);
+	kref_get(&hard_iface->refcount);
 
 	soft_iface = dev_get_by_name(net, iface_name);
 
@@ -765,7 +765,7 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 
 	hard_iface->if_status = BATADV_IF_INACTIVE;
 
-	kref_get(&hard_iface->refcount);
+	kref_get(&hard_iface->refcount);
 	hard_iface->batman_adv_ptype.type = ethertype;
 	hard_iface->batman_adv_ptype.func = batadv_batman_skb_recv;
 	hard_iface->batman_adv_ptype.dev = hard_iface->net_dev;
@@ -809,7 +809,7 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	hard_iface->soft_iface = NULL;
 	dev_put(soft_iface);
 err:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return ret;
 }
 
@@ -860,7 +860,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	batadv_info(hard_iface->soft_iface, "Removing interface: %s\n",
 		    hard_iface->net_dev->name);
 	dev_remove_pack(&hard_iface->batman_adv_ptype);
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
 	if (hard_iface == primary_if) {
@@ -870,7 +870,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 		batadv_primary_if_select(bat_priv, new_if);
 
 		if (new_if)
-			batadv_hardif_put(new_if);
+			batadv_hardif_put(new_if);
 	}
 
 	bat_priv->algo_ops->iface.disable(hard_iface);
@@ -893,11 +893,11 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	}
 
 	hard_iface->soft_iface = NULL;
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static struct batadv_hard_iface *
@@ -932,7 +932,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 
 	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	spin_lock_init(&hard_iface->neigh_list_lock);
-	kref_init(&hard_iface->refcount);
+	kref_init(&hard_iface->refcount);
 
 	hard_iface->num_bcasts = BATADV_NUM_BCASTS_DEFAULT;
 	hard_iface->wifi_flags = batadv_wifi_flags_evaluate(net_dev);
@@ -944,7 +944,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	batadv_v_hardif_init(hard_iface);
 
 	batadv_check_known_mac_addr(hard_iface->net_dev);
-	kref_get(&hard_iface->refcount);
+	kref_get(&hard_iface->refcount);
 	list_add_tail_rcu(&hard_iface->list, &batadv_hardif_list);
 	batadv_hardif_generation++;
 
@@ -973,7 +973,7 @@ static void batadv_hardif_remove_interface(struct batadv_hard_iface *hard_iface)
 	hard_iface->if_status = BATADV_IF_TO_BE_REMOVED;
 	batadv_debugfs_del_hardif(hard_iface);
 	batadv_sysfs_del_hardif(&hard_iface->hardif_obj);
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 }
 
 /**
@@ -986,6 +986,7 @@ void batadv_hardif_remove_interfaces(void)
 	rtnl_lock();
 	list_for_each_entry_safe(hard_iface, hard_iface_tmp,
 				 &batadv_hardif_list, list) {
+		printk("XXXXXXX %s\n", hard_iface->net_dev->name);
 		list_del_rcu(&hard_iface->list);
 		batadv_hardif_generation++;
 		batadv_hardif_remove_interface(hard_iface);
@@ -1027,6 +1028,7 @@ static int batadv_hard_if_event(struct notifier_block *this,
 	struct batadv_hard_iface *primary_if = NULL;
 	struct batadv_priv *bat_priv;
 
+	printk("YYYYYY %s %lu\n", net_dev->name, event);
 	if (batadv_softif_is_valid(net_dev))
 		return batadv_hard_if_event_softif(event, net_dev);
 
@@ -1086,10 +1088,10 @@ static int batadv_hard_if_event(struct notifier_block *this,
 	}
 
 hardif_put:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return NOTIFY_DONE;
 }
 
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index bad2e501..cdd948c8 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -108,13 +108,13 @@ int batadv_hardif_no_broadcast(struct batadv_hard_iface *if_outgoing,
 			       u8 *orig_addr, u8 *orig_neigh);
 
 /**
- * batadv_hardif_put() - decrement the hard interface refcounter and possibly
+ * batadv_hardif_put() - decrement the hard interface refcounter and possibly
  *  release it
  * @hard_iface: the hard interface to free
  */
-static inline void batadv_hardif_put(struct batadv_hard_iface *hard_iface)
+static inline void batadv_hardif_put(struct batadv_hard_iface *hard_iface)
 {
-	kref_put(&hard_iface->refcount, batadv_hardif_release);
+	kref_put(&hard_iface->refcount, batadv_hardif_release);
 }
 
 /**
@@ -133,7 +133,7 @@ batadv_primary_if_get_selected(struct batadv_priv *bat_priv)
 	if (!hard_iface)
 		goto out;
 
-	if (!kref_get_unless_zero(&hard_iface->refcount))
+	if (!kref_get_unless_zero(&hard_iface->refcount))
 		hard_iface = NULL;
 
 out:
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index 8bdabc03..2f32c2b0 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -278,7 +278,7 @@ static ssize_t batadv_socket_write(struct file *file, const char __user *buff,
 	kfree_skb(skb);
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (neigh_node)
 		batadv_neigh_node_put(neigh_node);
 	if (orig_node)
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 519c08c2..3134c1df 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -336,7 +336,7 @@ batadv_seq_print_text_primary_if_get(struct seq_file *seq)
 	seq_printf(seq,
 		   "BATMAN mesh %s disabled - primary interface not active\n",
 		   net_dev->name);
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	primary_if = NULL;
 
 out:
@@ -460,7 +460,7 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	 * shut down otherwise the packet may trigger de-reference errors
 	 * further down in the receive path.
 	 */
-	if (!kref_get_unless_zero(&hard_iface->refcount))
+	if (!kref_get_unless_zero(&hard_iface->refcount))
 		goto err_out;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
@@ -504,7 +504,7 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	idx = batadv_ogm_packet->packet_type;
 	(*batadv_rx_handler[idx])(skb, hard_iface);
 
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 
 	/* return NET_RX_SUCCESS in any case as we
 	 * most probably dropped the packet for
@@ -515,7 +515,7 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 err_free:
 	kfree_skb(skb);
 err_put:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 err_out:
 	return NET_RX_DROP;
 }
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index bdc4a1fb..f8f28c29 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -2152,7 +2152,7 @@ int batadv_mcast_flags_seq_print_text(struct seq_file *seq, void *offset)
 		rcu_read_unlock();
 	}
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	return 0;
 }
@@ -2361,7 +2361,7 @@ batadv_mcast_netlink_get_primary(struct netlink_callback *cb,
 	if (!ret && primary_if)
 		*primary_if = hard_iface;
 	else if (hard_iface)
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 
 	return ret;
 }
@@ -2389,7 +2389,7 @@ int batadv_mcast_flags_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	bat_priv = netdev_priv(primary_if->soft_iface);
 	ret = __batadv_mcast_flags_dump(msg, portid, cb, bat_priv, bucket, idx);
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	return ret;
 }
 
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index dc193618..115ea5e6 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -359,14 +359,14 @@ static int batadv_netlink_mesh_fill(struct sk_buff *msg,
 		goto nla_put_failure;
 
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	genlmsg_end(msg, hdr);
 	return 0;
 
 nla_put_failure:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -1217,7 +1217,7 @@ batadv_get_hardif_from_info(struct batadv_priv *bat_priv, struct net *net,
 	return hard_iface;
 
 err_put_hardif:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 err_put_harddev:
 	dev_put(hard_dev);
 
@@ -1336,7 +1336,7 @@ static void batadv_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	    info->user_ptr[1]) {
 		hard_iface = info->user_ptr[1];
 
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 
 	if (ops->internal_flags & BATADV_FLAG_NEED_VLAN && info->user_ptr[1]) {
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 48d70785..3de290b6 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1937,7 +1937,7 @@ int batadv_nc_nodes_seq_print_text(struct seq_file *seq, void *offset)
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 805d8969..7c1ae383 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -239,7 +239,7 @@ static void batadv_neigh_ifinfo_release(struct kref *ref)
 	neigh_ifinfo = container_of(ref, struct batadv_neigh_ifinfo, refcount);
 
 	if (neigh_ifinfo->if_outgoing != BATADV_IF_DEFAULT)
-		batadv_hardif_put(neigh_ifinfo->if_outgoing);
+		batadv_hardif_put(neigh_ifinfo->if_outgoing);
 
 	kfree_rcu(neigh_ifinfo, rcu);
 }
@@ -270,7 +270,7 @@ static void batadv_hardif_neigh_release(struct kref *ref)
 	hlist_del_init_rcu(&hardif_neigh->list);
 	spin_unlock_bh(&hardif_neigh->if_incoming->neigh_list_lock);
 
-	batadv_hardif_put(hardif_neigh->if_incoming);
+	batadv_hardif_put(hardif_neigh->if_incoming);
 	kfree_rcu(hardif_neigh, rcu);
 }
 
@@ -304,7 +304,7 @@ static void batadv_neigh_node_release(struct kref *ref)
 
 	batadv_hardif_neigh_put(neigh_node->hardif_neigh);
 
-	batadv_hardif_put(neigh_node->if_incoming);
+	batadv_hardif_put(neigh_node->if_incoming);
 
 	kfree_rcu(neigh_node, rcu);
 }
@@ -413,7 +413,7 @@ batadv_orig_ifinfo_new(struct batadv_orig_node *orig_node,
 		goto out;
 
 	if (if_outgoing != BATADV_IF_DEFAULT)
-		kref_get(&if_outgoing->refcount);
+		kref_get(&if_outgoing->refcount);
 
 	reset_time = jiffies - 1;
 	reset_time -= msecs_to_jiffies(BATADV_RESET_PROTECTION_MS);
@@ -491,7 +491,7 @@ batadv_neigh_ifinfo_new(struct batadv_neigh_node *neigh,
 		goto out;
 
 	if (if_outgoing)
-		kref_get(&if_outgoing->refcount);
+		kref_get(&if_outgoing->refcount);
 
 	INIT_HLIST_NODE(&neigh_ifinfo->list);
 	kref_init(&neigh_ifinfo->refcount);
@@ -570,7 +570,7 @@ batadv_hardif_neigh_create(struct batadv_hard_iface *hard_iface,
 	if (!hardif_neigh)
 		goto out;
 
-	kref_get(&hard_iface->refcount);
+	kref_get(&hard_iface->refcount);
 	INIT_HLIST_NODE(&hardif_neigh->list);
 	ether_addr_copy(hardif_neigh->addr, neigh_addr);
 	ether_addr_copy(hardif_neigh->orig, orig_node->orig);
@@ -682,7 +682,7 @@ batadv_neigh_node_create(struct batadv_orig_node *orig_node,
 	INIT_HLIST_HEAD(&neigh_node->ifinfo_list);
 	spin_lock_init(&neigh_node->ifinfo_lock);
 
-	kref_get(&hard_iface->refcount);
+	kref_get(&hard_iface->refcount);
 	ether_addr_copy(neigh_node->addr, neigh_addr);
 	neigh_node->if_incoming = hard_iface;
 	neigh_node->orig_node = orig_node;
@@ -756,7 +756,7 @@ int batadv_hardif_neigh_seq_print_text(struct seq_file *seq, void *offset)
 		   primary_if->net_dev->dev_addr, net_dev->name,
 		   bat_priv->algo_ops->name);
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	if (!bat_priv->algo_ops->neigh.print) {
 		seq_puts(seq,
@@ -835,11 +835,11 @@ int batadv_hardif_neigh_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
  out:
 	if (hardif)
-		batadv_hardif_put(hardif);
+		batadv_hardif_put(hardif);
 	if (hard_iface)
 		dev_put(hard_iface);
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (soft_iface)
 		dev_put(soft_iface);
 
@@ -859,7 +859,7 @@ static void batadv_orig_ifinfo_release(struct kref *ref)
 	orig_ifinfo = container_of(ref, struct batadv_orig_ifinfo, refcount);
 
 	if (orig_ifinfo->if_outgoing != BATADV_IF_DEFAULT)
-		batadv_hardif_put(orig_ifinfo->if_outgoing);
+		batadv_hardif_put(orig_ifinfo->if_outgoing);
 
 	/* this is the last reference to this object */
 	router = rcu_dereference_protected(orig_ifinfo->router, true);
@@ -1308,7 +1308,7 @@ static bool batadv_purge_orig_node(struct batadv_priv *bat_priv,
 		if (hard_iface->soft_iface != bat_priv->soft_iface)
 			continue;
 
-		if (!kref_get_unless_zero(&hard_iface->refcount))
+		if (!kref_get_unless_zero(&hard_iface->refcount))
 			continue;
 
 		best_neigh_node = batadv_find_best_neighbor(bat_priv,
@@ -1319,7 +1319,7 @@ static bool batadv_purge_orig_node(struct batadv_priv *bat_priv,
 		if (best_neigh_node)
 			batadv_neigh_node_put(best_neigh_node);
 
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 	rcu_read_unlock();
 
@@ -1406,7 +1406,7 @@ int batadv_orig_seq_print_text(struct seq_file *seq, void *offset)
 		   primary_if->net_dev->dev_addr, net_dev->name,
 		   bat_priv->algo_ops->name);
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	if (!bat_priv->algo_ops->orig.print) {
 		seq_puts(seq,
@@ -1461,7 +1461,7 @@ int batadv_orig_hardif_seq_print_text(struct seq_file *seq, void *offset)
 
 out:
 	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	return 0;
 }
 #endif
@@ -1532,11 +1532,11 @@ int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
  out:
 	if (hardif)
-		batadv_hardif_put(hardif);
+		batadv_hardif_put(hardif);
 	if (hard_iface)
 		dev_put(hard_iface);
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (soft_iface)
 		dev_put(soft_iface);
 
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 27cdf5e4..94ab9c83 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -280,7 +280,7 @@ static int batadv_recv_my_icmp_packet(struct batadv_priv *bat_priv,
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (orig_node)
 		batadv_orig_node_put(orig_node);
 
@@ -335,7 +335,7 @@ static int batadv_recv_icmp_ttl_exceeded(struct batadv_priv *bat_priv,
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (orig_node)
 		batadv_orig_node_put(orig_node);
 
@@ -796,7 +796,7 @@ batadv_reroute_unicast_packet(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	ret = true;
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (orig_node)
 		batadv_orig_node_put(orig_node);
 
@@ -907,7 +907,7 @@ static bool batadv_check_unicast_ttvn(struct batadv_priv *bat_priv,
 	unicast_packet->ttvn = curr_ttvn;
 	skb_postpush_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	return true;
 }
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index d267b948..c7b35fe0 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -310,7 +310,7 @@ bool batadv_send_skb_prepare_unicast_4addr(struct batadv_priv *bat_priv,
 	ret = true;
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return ret;
 }
 
@@ -475,9 +475,9 @@ void batadv_forw_packet_free(struct batadv_forw_packet *forw_packet,
 		consume_skb(forw_packet->skb);
 
 	if (forw_packet->if_incoming)
-		batadv_hardif_put(forw_packet->if_incoming);
+		batadv_hardif_put(forw_packet->if_incoming);
 	if (forw_packet->if_outgoing)
-		batadv_hardif_put(forw_packet->if_outgoing);
+		batadv_hardif_put(forw_packet->if_outgoing);
 	if (forw_packet->queue_left)
 		atomic_inc(forw_packet->queue_left);
 	kfree(forw_packet);
@@ -527,10 +527,10 @@ batadv_forw_packet_alloc(struct batadv_hard_iface *if_incoming,
 		goto err;
 
 	if (if_incoming)
-		kref_get(&if_incoming->refcount);
+		kref_get(&if_incoming->refcount);
 
 	if (if_outgoing)
-		kref_get(&if_outgoing->refcount);
+		kref_get(&if_outgoing->refcount);
 
 	INIT_HLIST_NODE(&forw_packet->list);
 	INIT_HLIST_NODE(&forw_packet->cleanup_list);
@@ -767,14 +767,14 @@ int batadv_add_bcast_packet_to_list(struct batadv_priv *bat_priv,
 
 	newskb = skb_copy(skb, GFP_ATOMIC);
 	if (!newskb) {
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 		goto err;
 	}
 
 	forw_packet = batadv_forw_packet_alloc(primary_if, NULL,
 					       &bat_priv->bcast_queue_left,
 					       bat_priv, newskb);
-	batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	if (!forw_packet)
 		goto err_packet_free;
 
@@ -932,7 +932,7 @@ static void batadv_send_outstanding_bcast_packet(struct work_struct *work)
 		if (neigh_node)
 			batadv_hardif_neigh_put(neigh_node);
 
-		if (!kref_get_unless_zero(&hard_iface->refcount))
+		if (!kref_get_unless_zero(&hard_iface->refcount))
 			continue;
 
 		/* send a copy of the saved skb */
@@ -940,7 +940,7 @@ static void batadv_send_outstanding_bcast_packet(struct work_struct *work)
 		if (skb1)
 			batadv_send_broadcast_skb(skb1, hard_iface);
 
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	}
 	rcu_read_unlock();
 
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 23833a0b..c059b099 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -395,7 +395,7 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (mcast_single_orig)
 		batadv_orig_node_put(mcast_single_orig);
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return NETDEV_TX_OK;
 }
 
@@ -893,7 +893,7 @@ static int batadv_softif_slave_add(struct net_device *dev,
 
 out:
 	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	return ret;
 }
 
@@ -920,7 +920,7 @@ static int batadv_softif_slave_del(struct net_device *dev,
 
 out:
 	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+		batadv_hardif_put(hard_iface);
 	return ret;
 }
 
diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index 0f962dcd..da12b0b4 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -282,7 +282,7 @@ ssize_t batadv_store_##_name(struct kobject *kobj,			\
 		batadv_netlink_notify_hardif(bat_priv, hard_iface);	\
 	}								\
 									\
-	batadv_hardif_put(hard_iface);				\
+	batadv_hardif_put(hard_iface);				\
 	return length;							\
 }
 
@@ -301,7 +301,7 @@ ssize_t batadv_show_##_name(struct kobject *kobj,			\
 									\
 	length = sprintf(buff, "%i\n", atomic_read(&hard_iface->_var));	\
 									\
-	batadv_hardif_put(hard_iface);				\
+	batadv_hardif_put(hard_iface);				\
 	return length;							\
 }
 
@@ -959,7 +959,7 @@ static ssize_t batadv_show_mesh_iface(struct kobject *kobj,
 
 	length = sprintf(buff, "%s\n", ifname);
 
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 
 	return length;
 }
@@ -1013,7 +1013,7 @@ static int batadv_store_mesh_iface_finish(struct net_device *net_dev,
 
 	ret = batadv_hardif_enable_interface(hard_iface, net, ifname);
 out:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return ret;
 }
 
@@ -1110,7 +1110,7 @@ static ssize_t batadv_show_iface_status(struct kobject *kobj,
 		break;
 	}
 
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 
 	return length;
 }
@@ -1170,7 +1170,7 @@ static ssize_t batadv_store_throughput_override(struct kobject *kobj,
 	}
 
 out:
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return count;
 }
 
@@ -1190,7 +1190,7 @@ static ssize_t batadv_show_throughput_override(struct kobject *kobj,
 
 	tp_override = atomic_read(&hard_iface->bat_v.throughput_override);
 
-	batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return sprintf(buff, "%u.%u MBit\n", tp_override / 10,
 		       tp_override % 10);
 }
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index db7e3774..fdb1f9c6 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -748,7 +748,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 	wake_up(&tp_vars->more_bytes);
 out:
 	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (likely(orig_node))
 		batadv_orig_node_put(orig_node);
 	if (likely(tp_vars))
@@ -882,7 +882,7 @@ static int batadv_tp_send(void *arg)
 
 out:
 	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (likely(orig_node))
 		batadv_orig_node_put(orig_node);
 
@@ -1207,7 +1207,7 @@ static int batadv_tp_send_ack(struct batadv_priv *bat_priv, const u8 *dst,
 	if (likely(orig_node))
 		batadv_orig_node_put(orig_node);
 	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	return ret;
 }
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 98a0aaaf..7b36fad9 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -820,7 +820,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	ret = true;
 out:
 	if (in_hardif)
-		batadv_hardif_put(in_hardif);
+		batadv_hardif_put(in_hardif);
 	if (in_dev)
 		dev_put(in_dev);
 	if (tt_local)
@@ -1135,7 +1135,7 @@ int batadv_tt_local_seq_print_text(struct seq_file *seq, void *offset)
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 #endif
@@ -1293,7 +1293,7 @@ int batadv_tt_local_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
  out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (soft_iface)
 		dev_put(soft_iface);
 
@@ -2007,7 +2007,7 @@ int batadv_tt_global_seq_print_text(struct seq_file *seq, void *offset)
 	}
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	return 0;
 }
 #endif
@@ -2214,7 +2214,7 @@ int batadv_tt_global_dump(struct sk_buff *msg, struct netlink_callback *cb)
 
  out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	if (soft_iface)
 		dev_put(soft_iface);
 
@@ -3198,7 +3198,7 @@ static bool batadv_send_tt_request(struct batadv_priv *bat_priv,
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 
 	if (ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
@@ -3461,7 +3461,7 @@ static bool batadv_send_my_tt_response(struct batadv_priv *bat_priv,
 	if (orig_node)
 		batadv_orig_node_put(orig_node);
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 	kfree(tvlv_tt_data);
 	/* The packet was for this host, so it doesn't need to be re-routed */
 	return true;
@@ -3785,7 +3785,7 @@ static void batadv_send_roam_adv(struct batadv_priv *bat_priv, u8 *client,
 
 out:
 	if (primary_if)
-		batadv_hardif_put(primary_if);
+		batadv_hardif_put(primary_if);
 }
 
 static void batadv_tt_purge(struct work_struct *work)
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index ed519efa..2fd42599 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -191,7 +191,7 @@ struct batadv_hard_iface {
 	struct kobject *hardif_obj;
 
 	/** @refcount: number of contexts the object is used */
-	struct kref refcount;
+	struct kref refcount;
 
 	/**
 	 * @batman_adv_ptype: packet type describing packets that should be

--nextPart3617159.Z5ivtThzXN--

--nextPart2573515.iUh7y9OTu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl8E0kgACgkQXYcKB8Em
e0YYqw/8DSrb+AScd+UYuK7fdp0hhq+nqe4kv3GZfXABnB+fMu9thRn9omaX8o1H
zrwmiGnojDIIJVqE0LVcmAei6a2G9MdsVX12RO6D3xXb8TeJ4sWi/YU6M7twdiR+
nAhusOAv7WOyJYslcTk4QzEyQD9B5H+xxe5MEACuD6Gdglm8t7bEpX+0vb2wC55G
DyVoAzZYSqM6LCYUKkorHucFgUXgFluZbPtv0wpUi+OYx4WSGAtZhEFET2jL3M2i
eMRwr2emak0C0+EGYVgPNzAmsm/cV9ujOtHcRxUx7NW6RrP0P2oXB3SdeHzJbeMD
rS+E+OVBnUCW4rY86iVF4PDunJUeVwmFb6diXU9j2uCOUKi0vgO20IPAFarcHmBO
qKOrhnEzpHi0+f3KGr92Q8r9iENGIuPXacIrbqhQ1lhGkm8J8IKuV23V02wGgea1
rBVKkomUXoVC01a6I54f6A3545DBaNxnQeBS+l112bGyalNov8cQKIsOhrMnWtEQ
ApqUSHQfVvgyPvAf3E2UZqwXwD5m2wLPq0NNcenEw9qwGgQqrxXU0rQP1DvDa2Cm
W6uO7XvTYl0NONDVHBHUAod0FGnIRMmUoaZ4Lrt0YW38jrHlWRAezyEVV3AGjZ5g
7Qz2IgQrQBgy0t0G3BoQJMPDXIpMrk/tFt0ewCMmwtuHLmNmwlE=
=PdO9
-----END PGP SIGNATURE-----

--nextPart2573515.iUh7y9OTu9--



