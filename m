Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C750481E
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiDQPB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 11:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQPB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 11:01:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D401AD9E
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 07:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650207532; x=1681743532;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Risly6dh7LNE4exm6ZoKciBlihSv+QYu8jD6pZaIKWI=;
  b=d73bg5JhKe8b/DQ3D2Lw+lw70QYzweHmaWDD+FnrwJTu8r5+18PBD6TD
   jss5/NKWRRsyCWfBeD0Mck/VwJYwUh/+mWwMGfb1eDtpWHcopYJ2pecNG
   oIqk44REZv5+orID/58xw5a60QXdmJHdDODPf3AVtWEIcxeZ3OSfaI/Dj
   oYETraftRpH0cQiSVwvPQK/cB1+rHcdTUppp5kOfbLhtqf8Be2v1gpeP/
   cLzPRsxC/iq41cajh5DgQdlduQomW5ckoH8enG5z7BKcugkr1DmOqUdF9
   +vcb26rCehsCab3uhckFmF5EsRPTzOzHyTwZqPitnNeTo72PDL29sL9Fx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="262249598"
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="262249598"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2022 07:58:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="528565983"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 17 Apr 2022 07:58:51 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ng6MU-000401-DD;
        Sun, 17 Apr 2022 14:58:50 +0000
Date:   Sun, 17 Apr 2022 22:58:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 398/403] net/ipv4/tcp_input.c:5966
 tcp_rcv_established() warn: unsigned 'reason' is never less than zero.
Message-ID: <202204172241.u3L04m3s-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   53c33a16d0688fc20b38e00dbbc2cb2b695e7020
commit: 4b506af9c5b8de0da34097d50d9448dfb33d70c3 [398/403] tcp: add two drop reasons for tcp_ack()
config: x86_64-randconfig-m001 (https://download.01.org/0day-ci/archive/20220417/202204172241.u3L04m3s-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

smatch warnings:
net/ipv4/tcp_input.c:5966 tcp_rcv_established() warn: unsigned 'reason' is never less than zero.

vim +/reason +5966 net/ipv4/tcp_input.c

  5781	
  5782	/*
  5783	 *	TCP receive function for the ESTABLISHED state.
  5784	 *
  5785	 *	It is split into a fast path and a slow path. The fast path is
  5786	 * 	disabled when:
  5787	 *	- A zero window was announced from us - zero window probing
  5788	 *        is only handled properly in the slow path.
  5789	 *	- Out of order segments arrived.
  5790	 *	- Urgent data is expected.
  5791	 *	- There is no buffer space left
  5792	 *	- Unexpected TCP flags/window values/header lengths are received
  5793	 *	  (detected by checking the TCP header against pred_flags)
  5794	 *	- Data is sent in both directions. Fast path only supports pure senders
  5795	 *	  or pure receivers (this means either the sequence number or the ack
  5796	 *	  value must stay constant)
  5797	 *	- Unexpected TCP option.
  5798	 *
  5799	 *	When these conditions are not satisfied it drops into a standard
  5800	 *	receive procedure patterned after RFC793 to handle all cases.
  5801	 *	The first three cases are guaranteed by proper pred_flags setting,
  5802	 *	the rest is checked inline. Fast processing is turned on in
  5803	 *	tcp_data_queue when everything is OK.
  5804	 */
  5805	void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
  5806	{
  5807		enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
  5808		const struct tcphdr *th = (const struct tcphdr *)skb->data;
  5809		struct tcp_sock *tp = tcp_sk(sk);
  5810		unsigned int len = skb->len;
  5811	
  5812		/* TCP congestion window tracking */
  5813		trace_tcp_probe(sk, skb);
  5814	
  5815		tcp_mstamp_refresh(tp);
  5816		if (unlikely(!rcu_access_pointer(sk->sk_rx_dst)))
  5817			inet_csk(sk)->icsk_af_ops->sk_rx_dst_set(sk, skb);
  5818		/*
  5819		 *	Header prediction.
  5820		 *	The code loosely follows the one in the famous
  5821		 *	"30 instruction TCP receive" Van Jacobson mail.
  5822		 *
  5823		 *	Van's trick is to deposit buffers into socket queue
  5824		 *	on a device interrupt, to call tcp_recv function
  5825		 *	on the receive process context and checksum and copy
  5826		 *	the buffer to user space. smart...
  5827		 *
  5828		 *	Our current scheme is not silly either but we take the
  5829		 *	extra cost of the net_bh soft interrupt processing...
  5830		 *	We do checksum and copy also but from device to kernel.
  5831		 */
  5832	
  5833		tp->rx_opt.saw_tstamp = 0;
  5834	
  5835		/*	pred_flags is 0xS?10 << 16 + snd_wnd
  5836		 *	if header_prediction is to be made
  5837		 *	'S' will always be tp->tcp_header_len >> 2
  5838		 *	'?' will be 0 for the fast path, otherwise pred_flags is 0 to
  5839		 *  turn it off	(when there are holes in the receive
  5840		 *	 space for instance)
  5841		 *	PSH flag is ignored.
  5842		 */
  5843	
  5844		if ((tcp_flag_word(th) & TCP_HP_BITS) == tp->pred_flags &&
  5845		    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
  5846		    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
  5847			int tcp_header_len = tp->tcp_header_len;
  5848	
  5849			/* Timestamp header prediction: tcp_header_len
  5850			 * is automatically equal to th->doff*4 due to pred_flags
  5851			 * match.
  5852			 */
  5853	
  5854			/* Check timestamp */
  5855			if (tcp_header_len == sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) {
  5856				/* No? Slow path! */
  5857				if (!tcp_parse_aligned_timestamp(tp, th))
  5858					goto slow_path;
  5859	
  5860				/* If PAWS failed, check it more carefully in slow path */
  5861				if ((s32)(tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent) < 0)
  5862					goto slow_path;
  5863	
  5864				/* DO NOT update ts_recent here, if checksum fails
  5865				 * and timestamp was corrupted part, it will result
  5866				 * in a hung connection since we will drop all
  5867				 * future packets due to the PAWS test.
  5868				 */
  5869			}
  5870	
  5871			if (len <= tcp_header_len) {
  5872				/* Bulk data transfer: sender */
  5873				if (len == tcp_header_len) {
  5874					/* Predicted packet is in window by definition.
  5875					 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
  5876					 * Hence, check seq<=rcv_wup reduces to:
  5877					 */
  5878					if (tcp_header_len ==
  5879					    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
  5880					    tp->rcv_nxt == tp->rcv_wup)
  5881						tcp_store_ts_recent(tp);
  5882	
  5883					/* We know that such packets are checksummed
  5884					 * on entry.
  5885					 */
  5886					tcp_ack(sk, skb, 0);
  5887					__kfree_skb(skb);
  5888					tcp_data_snd_check(sk);
  5889					/* When receiving pure ack in fast path, update
  5890					 * last ts ecr directly instead of calling
  5891					 * tcp_rcv_rtt_measure_ts()
  5892					 */
  5893					tp->rcv_rtt_last_tsecr = tp->rx_opt.rcv_tsecr;
  5894					return;
  5895				} else { /* Header too small */
  5896					reason = SKB_DROP_REASON_PKT_TOO_SMALL;
  5897					TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
  5898					goto discard;
  5899				}
  5900			} else {
  5901				int eaten = 0;
  5902				bool fragstolen = false;
  5903	
  5904				if (tcp_checksum_complete(skb))
  5905					goto csum_error;
  5906	
  5907				if ((int)skb->truesize > sk->sk_forward_alloc)
  5908					goto step5;
  5909	
  5910				/* Predicted packet is in window by definition.
  5911				 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
  5912				 * Hence, check seq<=rcv_wup reduces to:
  5913				 */
  5914				if (tcp_header_len ==
  5915				    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
  5916				    tp->rcv_nxt == tp->rcv_wup)
  5917					tcp_store_ts_recent(tp);
  5918	
  5919				tcp_rcv_rtt_measure_ts(sk, skb);
  5920	
  5921				NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);
  5922	
  5923				/* Bulk data transfer: receiver */
  5924				__skb_pull(skb, tcp_header_len);
  5925				eaten = tcp_queue_rcv(sk, skb, &fragstolen);
  5926	
  5927				tcp_event_data_recv(sk, skb);
  5928	
  5929				if (TCP_SKB_CB(skb)->ack_seq != tp->snd_una) {
  5930					/* Well, only one small jumplet in fast path... */
  5931					tcp_ack(sk, skb, FLAG_DATA);
  5932					tcp_data_snd_check(sk);
  5933					if (!inet_csk_ack_scheduled(sk))
  5934						goto no_ack;
  5935				} else {
  5936					tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
  5937				}
  5938	
  5939				__tcp_ack_snd_check(sk, 0);
  5940	no_ack:
  5941				if (eaten)
  5942					kfree_skb_partial(skb, fragstolen);
  5943				tcp_data_ready(sk);
  5944				return;
  5945			}
  5946		}
  5947	
  5948	slow_path:
  5949		if (len < (th->doff << 2) || tcp_checksum_complete(skb))
  5950			goto csum_error;
  5951	
  5952		if (!th->ack && !th->rst && !th->syn) {
  5953			reason = SKB_DROP_REASON_TCP_FLAGS;
  5954			goto discard;
  5955		}
  5956	
  5957		/*
  5958		 *	Standard slow path.
  5959		 */
  5960	
  5961		if (!tcp_validate_incoming(sk, skb, th, 1))
  5962			return;
  5963	
  5964	step5:
  5965		reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
> 5966		if (reason < 0)
  5967			goto discard;
  5968	
  5969		tcp_rcv_rtt_measure_ts(sk, skb);
  5970	
  5971		/* Process urgent data. */
  5972		tcp_urg(sk, skb, th);
  5973	
  5974		/* step 7: process the segment text */
  5975		tcp_data_queue(sk, skb);
  5976	
  5977		tcp_data_snd_check(sk);
  5978		tcp_ack_snd_check(sk);
  5979		return;
  5980	
  5981	csum_error:
  5982		reason = SKB_DROP_REASON_TCP_CSUM;
  5983		trace_tcp_bad_csum(skb);
  5984		TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
  5985		TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
  5986	
  5987	discard:
  5988		tcp_drop_reason(sk, skb, reason);
  5989	}
  5990	EXPORT_SYMBOL(tcp_rcv_established);
  5991	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
