Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0877534AA2
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiEZHEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiEZHEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:04:36 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405674B4E5;
        Thu, 26 May 2022 00:04:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VER5Ho7_1653548667;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VER5Ho7_1653548667)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 May 2022 15:04:28 +0800
Date:   Thu, 26 May 2022 15:04:27 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Message-ID: <Yo8me+RzNhIUGAZ3@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 03:42:28PM +0200, Alexandra Winter wrote:
> 
> 
> On 24.05.22 09:49, Tony Lu wrote:
> > On Tue, May 24, 2022 at 02:52:07PM +0800, D. Wythe wrote:
> >> From: "D. Wythe" <alibuda@linux.alibaba.com>
> >>
> >> Hi Karsten,
> >>
> >> We are promoting SMC-R to the field of cloud computing, dues to the
> >> particularity of business on the cloud, the scale and the types of
> >> customer applications are unpredictable. As a participant of SMC-R, we
> >> also hope that SMC-R can cover more application scenarios. Therefore,
> >> many connection problems are exposed during this time. There are two
> >> main issue, one is that the establishment of a single connection takes
> >> longer than that of the TCP, another is that the degree of concurrency
> >> is low under multi-connection processing. This patch set is mainly
> >> optimized for the first issue, and the follow-up of the second issue
> >> will be synchronized in the future.
> >>
> >> In terms of communication process, under current implement, a TCP
> >> three-way handshake only needs 1-RTT time, while SMC-R currently
> >> requires 4-RTT times, including 2-RTT over IP(TCP handshake, SMC
> >> proposal & accept ) and 2-RTT over IB ( two times RKEY exchange), which
> >> is most influential factor affecting connection established time at the
> >> moment.
> >>
> >> We have noticed that single network interface card is mainstream on the
> >> cloud, dues to the advantages of cloud deployment costs and the cloud's
> >> own disaster recovery support. On the other hand, the emergence of RoCE
> >> LAG technology makes us no longer need to deal with multiple RDMA
> >> network interface cards by ourselves,  just like NIC bonding does. In
> >> Alibaba, Roce LAG is widely used for RDMA.
> > 
> > I think this is an interesting topic whether we need SMC-level link
> > redundancy. I agreed with that RoCE LAG and RDMA in cloud vendors handle
> > redundancy and failover in the lower layer, and do it transparently for
> > SMC.
> > 
> > So let's move on, if a RDMA device has redundancy ability, we could make
> > SMC simpler by give an option for user-space or based on the device
> > capability (if we have this flag). This allows under layer to ensure the
> > reliability of link group.
> > 
> > As RFC 7609 mentioned, we should do some extra work for reliability to
> > add link. It should be an optional work if the device have capability
> > for redundancy, and make link group simpler and faster (for the
> > so-called SMC-2RTT in this RFC).
> > 
> > I also notice that RFC 7609 is released on August 2015, which is earlier
> > than RoCE LAG. RoCE LAG is provided after ConnectX-3/ConnectX-3 Pro in
> > kernel 4.0, and is available in 2017. And cloud vendors' RDMA adapters,
> > such as Alibaba Elastic RDMA adapter in [1].
> > 
> > Given that, I propose whether the second link can be used as an option
> > in newly created link group. Also, if it is possible, RFC 7609 can be
> > updated or extend it for this nowadays case.
> > 
> > Looking forward for your message, Karsten, D. Wythe and folks.
> > 
> > [1] https://lore.kernel.org/linux-rdma/20220523075528.35017-1-chengyou@linux.alibaba.com/
> > 
> > Thanks,
> > Tony Lu
> >  
> Thank you D. Wythe for your proposals, the prototype and measurements.
> They sound quite promising to us.
> 
> We need to carefully evaluate them and make sure everything is compatible
> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
> typical s390 environment ROCE LAG is propably not good enough, as the card
> is still a single point of failure. So your ideas need to be compatible
> with link redundancy. We also need to consider that the extension of the
> protocol does not block other desirable extensions.
> 
> Your prototype is very helpful for the understanding. Before submitting any
> code patches to net-next, we should agree on the details of the protocol
> extension. Maybe you could formulate your proposal in plain text, so we can
> discuss it here? 
> 
> We also need to inform you that several public holidays are upcoming in the
> next weeks and several of our team will be out for summer vacation, so please
> allow for longer response times.
> 
> Kind regards
> Alexandra Winter
> 
It's glad to hear this. This gave us a lot of confidence to insist on
it, thank you.

Cheers,
Tony Lu
