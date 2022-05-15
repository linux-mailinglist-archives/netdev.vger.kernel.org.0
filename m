Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCD35277F0
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiEOOJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 10:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiEOOJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 10:09:20 -0400
X-Greylist: delayed 283 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 May 2022 07:09:19 PDT
Received: from mifar.in (mifar.in [161.35.211.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7223524082
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 07:09:19 -0700 (PDT)
Received: from mifar.in (dsl-hkibng21-54f8c5-176.dhcp.inet.fi [84.248.197.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ED448
         client-signature ED448)
        (Client CN "mutt.mifar.in", Issuer "ca.mifar.in" (verified OK))
        by mifar.in (Postfix) with ESMTPS id 7CFB13F987
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 14:04:34 +0000 (UTC)
Date:   Sun, 15 May 2022 17:04:32 +0300
From:   Sami Farin <hvtaifwkbgefbaei@gmail.com>
To:     Linux Networking Mailing List <netdev@vger.kernel.org>
Subject: sockets staying in FIN-WAIT-1, CLOSING, or LAST-ACK state till reboot
Message-ID: <20220515140001.cws3pgz4iaaanpjo@m.mifar.in>
Mail-Followup-To: Sami Farin <hvtaifwkbgefbaei@gmail.com>,
        Linux Networking Mailing List <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_20,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_PASS,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1618]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  0.0 DKIM_ADSP_CUSTOM_MED No valid author signature, adsp_override
        *      is CUSTOM_MED
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hvtaifwkbgefbaei[at]gmail.com]
        *  1.0 FORGED_GMAIL_RCVD 'From' gmail.com does not match 'Received'
        *      headers
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.9 NML_ADSP_CUSTOM_MED ADSP custom_med hit, and not from a mailing
        *       list
        *  1.0 SPOOFED_FREEMAIL No description available.
        *  1.3 SPOOF_GMAIL_MID From Gmail but it doesn't seem to be...
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

with 5.15.37, ss -K -t does not properly kill the TCP sockets.
[ Disclaimer: this is my guess of the culprit.  I also use wireguard. ]

tcp          FIN-WAIT-1        0             1                                               80.220.8.55:22384                   91.198.174.208:443             ino:0 sk:510b cgroup:unreachable:6c46 ---
	 skmem:(r0,rb87380,t0,tb130560,f0,w0,o0,bl0,d0) ts sack ecn ecnseen bbr wscale:9,10 rto:3744 rtt:33.364/18.714 ato:40 mss:36 pmtu:68 rcvmss:536 advmss:1448 cwnd:1 bytes_sent:701 bytes_acked:702 bytes_received:254 segs_out:6 segs_in:3 data_segs_out:2 data_segs_in:1 bbr:(bw:10176bps,mrtt:27.924,pacing_gain:2.88672,cwnd_gain:2.88672) send 8632bps lastsnd:601107881 lastrcv:601107884 lastack:601107810 pacing_rate 11658680bps delivery_rate 10192bps delivered:3 app_limited busy:23371222ms lost:1 rcv_space:14480 rcv_ssthresh:42242 minrtt:27.924

$ nc -l -p 22384
Ncat: bind to 0.0.0.0:22384: Address already in use. QUITTING.
$ nc -l 127.0.0.1 22384
^C
$

These zombie sockets all have Send-Q > 0.

-- 
Do what you love because life is too short for anything else.

