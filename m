Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AF96E5BC1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDRINA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjDRIMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0943530CB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681805460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9LaUC9tg4G2l6nVpqrdOieDitZKZLzXClLpOb7J+e8k=;
        b=X98B6H9+zCFZfOpu+Irjdp0I4XPNukgwQbQhFZdwYfCqtY9DEOv5ebk62+oSwyzQFN8cvv
        SGbpsh4QdKb1gqIGRmGy/KQilkpaEyLVTf02ueelAY6DGAi5+ajpat8IKVKOBwUojkitSL
        h2Jc0qMMORvWSNWcKXchp+xZ1FTwc4Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-6CL2NmDjNOunPgRLVXfmtA-1; Tue, 18 Apr 2023 04:03:58 -0400
X-MC-Unique: 6CL2NmDjNOunPgRLVXfmtA-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b003f175816f47so1233811wms.5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681805037; x=1684397037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LaUC9tg4G2l6nVpqrdOieDitZKZLzXClLpOb7J+e8k=;
        b=NoWH1BT9CEAu7+MvdesBcQy9qcre64DpLqkm3jAPf3nDjGkO8vGY/govb2lqjzcnn9
         arUStQWnH5eZ/plKdG7Rp6hGQVxSlto7Pe4NKMCrRlDjVCYEbAMhz/2PfejOIq//2gpT
         3Mrwtb/SEv9Guj7kXw6TpnA79tM5E6S8unjFPPhOWjwjR6gG1xRDMGbRsSmLorL+j8mP
         uFBSwFoPKM/KJJNwnWb9SNDsPxPr780s6MEB5aqmTCOkmNq5vGTNo2AUt1kOXfce0nGt
         brpa3IjRY9Tsj9KB2JTzCeu/z2noLnOWWwW9pmriwPajyhjar5K3nNd1HT0562wog/0y
         TlBQ==
X-Gm-Message-State: AAQBX9eWC+3U6Bf1JR8luiZVU3k2UqdFbnXXF5BIDY89NNqiFNlwdqj6
        iJCedzW6DBRKb9UTs08iimncCfSvw46VN1rqLtw3zybjAcijhpC0BQD9IMNi5n9HfgMyVXrAIA2
        /7mDvEgW2U+DrucBS
X-Received: by 2002:a7b:cd10:0:b0:3ee:672d:caa3 with SMTP id f16-20020a7bcd10000000b003ee672dcaa3mr13809177wmj.18.1681805036825;
        Tue, 18 Apr 2023 01:03:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350YgRexEYOBjpcJXKFiZdltKyrmIp9qx+iJEmZye/XjE1blMO25oLBRoJBR3OVmGLoZhVR2fng==
X-Received: by 2002:a7b:cd10:0:b0:3ee:672d:caa3 with SMTP id f16-20020a7bcd10000000b003ee672dcaa3mr13809158wmj.18.1681805036491;
        Tue, 18 Apr 2023 01:03:56 -0700 (PDT)
Received: from debian ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c021a00b003f17848673fsm1720374wmi.27.2023.04.18.01.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 01:03:56 -0700 (PDT)
Date:   Tue, 18 Apr 2023 10:03:53 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <ZD5O6VzyEAggakb2@debian>
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZDx2IUYTmLSdzU6D@codewreck.org>
 <20230416224316.xlvgjor65nejldwh@begin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416224316.xlvgjor65nejldwh@begin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 12:43:16AM +0200, Samuel Thibault wrote:
> Dominique Martinet, le lun. 17 avril 2023 07:26:41 +0900, a ecrit:
> > Also, this got me wondering if the 'if' fd can be closed immediately or
> > if the interface will be removed when the fd is closed (probably not?)
> 
> Closing the fd would close the if, yes. AIUI one really has to keep the
> pppox socket (for stats), the ppp chan (for non-data ppp packets), and
> the ppp if (for the if).

L2TP has control and data packets. The L2TP socket is there to handle
L2TP control packets in user space, as the kernel only handles L2TP
data packets. You have to keep the L2TP session socket open, otherwise
you can't handle the session anymore.

Then there are the PPP file descriptors. A PPP channel is used to send
and receive PPP frames. It has to be associated with a lower transport,
for example an L2TP session if you want to encapsulate PPP into L2TP.
But that could be something else (a PPPoE session, a serial link, etc.).
Same as for L2TP session sockets, you need to keep the PPP channel fd
open, otherwise you can't handle the PPP session anymore.

Finally there are PPP units. A PPP unit represents the PPP networking
device (like ppp0). A PPP unit has to be associated with a PPP channel
(or several PPP channels for multilink PPP, but better avoid that). A
PPP unit doesn't know how to send packets, it delegates that to its PPP
channels.

You can avoid creating PPP units if you don't need a PPP network
device. In particular, if you're forwarding a PPP session between a
PPPoE and an L2TP session (or between two different L2TP sesions), you
typically don't need to create any PPP unit. You handle the initial LCP
negociation and PPP authentication using a PPP channel on the incoming
side, then you create another PPP channel on the other side (where you
want to forward the incoming PPP session) and finally bridge them
together with PPPIOCBRIDGECHAN.

> Samuel
> 

