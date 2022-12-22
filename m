Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEA66542CE
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiLVOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 09:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiLVOXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 09:23:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B0828717
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 06:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671718938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMgekTLXsAQ2q0wUPkhRLoJ34D3Iu1pE56+7MU/IOrE=;
        b=HoCeU96SSJdFZ+cOW/h7Ml1uPssEF+GZWQcfw4fXwUgGp+ybs+5ty4qsXT7ihjZ9Xq5hof
        OC8A1qGmqy1VAMxU6kWx8DLi4Cjo3K7tvfdcZwkgRcSA9oEsY2GNkvh8JP/5GZivBCloqL
        jh/LWAn+P1ytsVlwElck0rpMzgow4RU=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-Zq6tKMp0PCW7cS6TJ6Z_uA-1; Thu, 22 Dec 2022 09:22:16 -0500
X-MC-Unique: Zq6tKMp0PCW7cS6TJ6Z_uA-1
Received: by mail-vs1-f69.google.com with SMTP id h6-20020a056102104600b003b1371d70e8so453316vsq.11
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 06:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mMgekTLXsAQ2q0wUPkhRLoJ34D3Iu1pE56+7MU/IOrE=;
        b=8Mz6p879MhZxYHRXMehL57pZ2bH4uwksfUVhVWaOQTpF4fUf0ND+/mVjCJXgG0CdOG
         VT6zZkgmyevRodkEfJipj151f8wSm/MSI3gmAjs4FnH7rDMDGgoF6m8gWwLibP3HZlV3
         Wku738m8VglMHs+01oUqfAhfnanWWG1egF8VsjectMM2cTfXCVXTqbtpOtePQZ2LsZIH
         yTixpsQina4MMZJ2Ytz3/pfERFfORkOmXxGWFeAe1gXqzxaQju5uTqTWBDIjp/PeDvp1
         /cUmJm67LuFlf9aIt+z7mvY8vYLJa6swoxEpWW6DQLC3ahXzcDse9e6gzrLnGNSPriOG
         aXyw==
X-Gm-Message-State: AFqh2kqf3hzOdW+X1xzfmMBknaBI2zPqeCDRTaQKUx+WGsJTrRWvcBU8
        LEDXUW6q+cLl6DbqN56YrCgO1TIZCwx2XroI+/buCMxq3ktp24sM1r2HH9XBpSCaArxxWl4ytFQ
        2xKxwjtIrfAorJXcG
X-Received: by 2002:a67:eb5a:0:b0:3b5:1c66:8462 with SMTP id x26-20020a67eb5a000000b003b51c668462mr2629841vso.12.1671718935773;
        Thu, 22 Dec 2022 06:22:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtwyw9Z+LcJ9dpEG9P9afhFXLi0GxMfLp+zU4iEXlv4iTOSPG+1dv6HL0kIQQrmS+UX20ycGw==
X-Received: by 2002:a67:eb5a:0:b0:3b5:1c66:8462 with SMTP id x26-20020a67eb5a000000b003b51c668462mr2629819vso.12.1671718935509;
        Thu, 22 Dec 2022 06:22:15 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id bq43-20020a05620a46ab00b0070209239b87sm380834qkb.41.2022.12.22.06.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:22:14 -0800 (PST)
Message-ID: <0efd4a7072fb90cc9bc9992b00d9ade233a38de1.camel@redhat.com>
Subject: Re: [PATCH net 0/8] Add support for two classes of VCAP rules
From:   Paolo Abeni <pabeni@redhat.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     UNGLinuxDriver@microchip.com, Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Date:   Thu, 22 Dec 2022 15:22:10 +0100
In-Reply-To: <20221221132517.2699698-1-steen.hegelund@microchip.com>
References: <20221221132517.2699698-1-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
On Wed, 2022-12-21 at 14:25 +0100, Steen Hegelund wrote:
> This adds support for two classes of VCAP rules:
> 
> - Permanent rules (added e.g. for PTP support)
> - TC user rules (added by the TC userspace tool)
> 
> For this to work the VCAP Loopups must be enabled from boot, so that the
> "internal" clients like PTP can add rules that are always active.
> 
> When the TC tool add a flower filter the VCAP rule corresponding to this
> filter will be disabled (kept in memory) until a TC matchall filter creates
> a link from chain 0 to the chain (lookup) where the flower filter was
> added.
> 
> When the flower filter is enabled it will be written to the appropriate
> VCAP lookup and become active in HW.
> 
> Likewise the flower filter will be disabled if there is no link from chain
> 0 to the chain of the filter (lookup), and when that happens the
> corresponding VCAP rule will be read from the VCAP instance and stored in
> memory until it is deleted or enabled again.

Despite the 'net' target, this looks really like net-next material as
most patches look like large refactor. I see there are a bunch of fixes
in patches 3-8, but quite frankly it's not obvious at all what the
refactors/new features described into the commit messages themself
really fix.

I suggest to move this series to net-next (and thus repost after Jan
2), unless you come-up with some good reasons to keep it in net.

Thanks,

Paolo

