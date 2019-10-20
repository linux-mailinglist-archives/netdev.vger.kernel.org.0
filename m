Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C125BDE065
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 22:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfJTUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 16:25:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfJTUZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 16:25:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9DC3F6030D; Sun, 20 Oct 2019 20:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571603149;
        bh=zxNfy8hatVMcx9NJha24ygdy+yCtbsBcY/HigKecYAo=;
        h=Date:From:To:Subject:From;
        b=atSlp/UwufaXHdm8ItdP4lmcESwVONZLY2ryOM8+CftzXL2U2KjGOKtSp2seoCEL7
         QyghVo0Z+UKaTyb++Xd2kgjBswIp5fUxb9yf3t6LoSNQ1FYfHFVc6hFiEw8J+/HfzH
         pPzv29V3MZpWtdFRY78RHKcgfhA8mc0Py89adlsw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 1ACD6602C8;
        Sun, 20 Oct 2019 20:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571603149;
        bh=zxNfy8hatVMcx9NJha24ygdy+yCtbsBcY/HigKecYAo=;
        h=Date:From:To:Subject:From;
        b=atSlp/UwufaXHdm8ItdP4lmcESwVONZLY2ryOM8+CftzXL2U2KjGOKtSp2seoCEL7
         QyghVo0Z+UKaTyb++Xd2kgjBswIp5fUxb9yf3t6LoSNQ1FYfHFVc6hFiEw8J+/HfzH
         pPzv29V3MZpWtdFRY78RHKcgfhA8mc0Py89adlsw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Oct 2019 14:25:49 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     netdev@vger.kernel.org, ycheng@google.com, eric.dumazet@gmail.com,
        ncardwell@google.com
Subject: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
Message-ID: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are seeing a crash in the TCP ACK codepath often in our regression
racks with an ARM64 device with 4.19 based kernel.

It appears that the tp->highest_ack is invalid when being accessed when 
a
FIN-ACK is received. In all the instances of the crash, the tcp socket
is in TCP_FIN_WAIT1 state.

[include/net/tcp.h]
static inline u32 tcp_highest_sack_seq(struct tcp_sock *tp)
{
	if (!tp->sacked_out)
		return tp->snd_una;

	if (tp->highest_sack == NULL)
		return tp->snd_nxt;

	return TCP_SKB_CB(tp->highest_sack)->seq;
}

[net/ipv4/tcp_input.c]
static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
{
...
	prior_fack = tcp_is_sack(tp) ? tcp_highest_sack_seq(tp) : tp->snd_una;


Crash call stack below-

  16496.596106:   <6> Unable to handle kernel paging request at virtual 
address fffffff2cd81a368
  16496.730771:   <2> pc : tcp_ack+0x174/0x11e8
  16496.734536:   <2> lr : tcp_rcv_state_process+0x318/0x1300
  16497.183109:   <2> Call trace:
  16497.183114:   <2>  tcp_ack+0x174/0x11e8
  16497.183115:   <2>  tcp_rcv_state_process+0x318/0x1300
  16497.183117:   <2>  tcp_v4_do_rcv+0x1a8/0x1f0
  16497.183118:   <2>  tcp_v4_rcv+0xe90/0xec8
  16497.183120:   <2>  ip_protocol_deliver_rcu+0x150/0x298
  16497.183121:   <2>  ip_local_deliver+0x21c/0x2a8
  16497.183122:   <2>  ip_rcv+0x1c4/0x210
  16497.183124:   <2>  __netif_receive_skb_core+0xab0/0xd90
  16497.183125:   <2>  netif_receive_skb_internal+0x12c/0x368
  16497.183126:   <2>  napi_gro_receive+0x1e0/0x290

Is it expected for the tp->highest_ack to be
accessed in this state?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
