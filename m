Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335F853A041
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350286AbiFAJZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350089AbiFAJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:25:03 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F4813D0;
        Wed,  1 Jun 2022 02:25:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VF2we-e_1654075497;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VF2we-e_1654075497)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Jun 2022 17:24:57 +0800
Date:   Wed, 1 Jun 2022 17:24:56 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Message-ID: <YpcwaNLUtPyzPBgc@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
 <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 02:33:09PM +0800, D. Wythe wrote:
> 
> ÔÚ 2022/5/25 ÏÂÎç9:42, Alexandra Winter Ð´µÀ:
> 
> > We need to carefully evaluate them and make sure everything is compatible
> > with the existing implementations of SMC-D and SMC-R v1 and v2. In the
> > typical s390 environment ROCE LAG is propably not good enough, as the card
> > is still a single point of failure. So your ideas need to be compatible
> > with link redundancy. We also need to consider that the extension of the
> > protocol does not block other desirable extensions.
> > 
> > Your prototype is very helpful for the understanding. Before submitting any
> > code patches to net-next, we should agree on the details of the protocol
> > extension. Maybe you could formulate your proposal in plain text, so we can
> > discuss it here?
> > 
> > We also need to inform you that several public holidays are upcoming in the
> > next weeks and several of our team will be out for summer vacation, so please
> > allow for longer response times.
> > 
> > Kind regards
> > Alexandra Winter
> > 
> 
> Hi alls,
> 
> In order to achieve signle-link compatibility, we must
> complete at least once negotiation. We wish to provide
> higher scalability while meeting this feature. There are
> few ways to reach this.
> 
> 1. Use the available reserved bits. According to
> the SMC v2 protocol, there are at least 28 reserved octets
> in PROPOSAL MESSAGE and at least 10 reserved octets in
> ACCEPT MESSAGE are available. We can define an area in which
> as a feature area, works like bitmap. Considering the subsequent
> scalability, we MAY use at least 2 reserved ctets, which can support
> negotiation of at least 16 features.
> 
> 2. Unify all the areas named extension in current
> SMC v2 protocol spec without reinterpreting any existing field
> and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
> 'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
> the ability to grow dynamically as needs expand. This scheme will use
> at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 reserved
> octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we only need to
> use reserved fields, and the current reserved fields are sufficient. And
> then we can easily add a new extension named SIGNLE LINK. Limited by space,
> the details will be elaborated after the scheme is finalized.

After reading this and latest version of protocol, I agree with that the
idea to provide a more flexible extension facilities. And, it's a good
chance for us to set here talking about the protocol extension.

There are some potential scenarios that need flexible extensions in my
mind:
- other protocols support, such as iWARP / IB or new version protocol,
- dozens of feature flags in the future, like this proposal. With the
  growth of new feature, it could overflow bitmap.

Actually, this extension facilities are very similar to TCP options.

So what about your opinions about the solution of this? If there are
some existed approaches for the future extensions, maybe this can get
involved in it. Or we can start a discuss about this as this mail
mentioned.

Also, I am wondering if there is plan to update the RFC7609, add the
latest v2 support?

Thanks,
Tony Lu
