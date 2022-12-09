Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685C264832C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLIOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIOFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:05:04 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8601572856;
        Fri,  9 Dec 2022 06:05:03 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 591661D2A;
        Fri,  9 Dec 2022 15:05:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670594701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2YpDJExtWrn75eERpM+XzkW1nqJfI2pmtL3qmKW7EzA=;
        b=zX8/PUNdaBaxPoSJ4n9rhzUf+l3ji7UlL+QRJMRzT6Mu4qFVzSEdeAm1ThWrnJU3ANlMhY
        9RAlIhCpyF39JQ3Sj2qGLqPExZboJinxhgdWUCIWCvXQtsIteB8/9J95lovnf6JyJHI/CN
        YeA7vd80KskZG549v6xnBkjt75n6eHLYDJqka3IUlXXsFnh/8r/vJ+l1fVwK8b/lY8AjDw
        he0B7/m/xUAFyxhCOY+D/xwwzXkVk/d2FGRNiGKTLlMwFQZluI3/YUpl+ne1sbnwd5D6FM
        hY0amjHPtxQrE99V8zasG7kYG8q+eDl3h0uYtNCPeXerv7+2klulpFtXZWZcFw==
MIME-Version: 1.0
Date:   Fri, 09 Dec 2022 15:05:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        daniel.machon@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
In-Reply-To: <20221209125611.m5cp3depjigs7452@skbuf>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-09 13:56, schrieb Vladimir Oltean:
> On Fri, Dec 09, 2022 at 01:58:57PM +0100, Horatiu Vultur wrote:
>> > Does it also work out of the box with the following patch if
>> > the interface is part of a bridge or do you still have to do
>> > the tc magic from above?
>> 
>> You will still need to enable the TCAM using the tc command to have it
>> working when the interface is part of the bridge.
> 
> FWIW, with ocelot (same VCAP mechanism), PTP traps work out of the box,
> no need to use tc. Same goes for ocelot-8021q, which also uses the 
> VCAP.
> I wouldn't consider forcing the user to add any tc command in order for
> packet timestamping to work properly.

+1
Esp. because there is no warning. I.e. I tried this patch while
the interface was added on a bridge and there was no error
whatsoever. Also, you'd force the user to have that Kconfig option
set.

-michael

