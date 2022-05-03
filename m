Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19D251855E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiECN0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiECN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:26:07 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEAC36E25;
        Tue,  3 May 2022 06:22:34 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1384822249;
        Tue,  3 May 2022 15:22:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651584153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyqmpwcG9NfAtn1s3UbgQocJOvUe8NcEf4lgtMi+A20=;
        b=hCoRE4nzU3wfE/HOVxOpMuaCmr9Y+uTAxNF7gAEJ0YRJIWAAp2DOiDGrXVyT/W6gAxrp2L
        DBIUTqj1Gu080JZLvAvamX/TX+E30yamZlGUy88FmXcGi/Fznt9DCoLseGXDWQsXyXGeFi
        ZqVVdRISEFdzRy78gf+laCH8SZWXG8o=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 May 2022 15:22:32 +0200
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: lan966x: remove PHY reset
In-Reply-To: <CAL_JsqKmgsErk41D8MBsQxLfmk16UYVu8+Z5SkwJ6W-obhtysQ@mail.gmail.com>
References: <20220428114049.1456382-1-michael@walle.cc>
 <20220428114049.1456382-2-michael@walle.cc>
 <CAL_JsqKmgsErk41D8MBsQxLfmk16UYVu8+Z5SkwJ6W-obhtysQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1b9e64238a5f70392f379560c884f72b@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-05-03 15:04, schrieb Rob Herring:
> On Thu, Apr 28, 2022 at 6:40 AM Michael Walle <michael@walle.cc> wrote:
>> 
>> The PHY reset was intended to be a phandle for a special PHY reset
>> driver for the integrated PHYs as well as any external PHYs. It turns
>> out, that the culprit is how the reset of the switch device is done.
>> In particular, the switch reset also affects other subsystems like
>> the GPIO and the SGPIO block and it happens to be the case that the
>> reset lines of the external PHYs are connected to a common GPIO line.
>> Thus as soon as the switch issues a reset during probe time, all the
>> external PHYs will go into reset because all the GPIO lines will
>> switch to input and the pull-down on that signal will take effect.
>> 
>> So even if there was a special PHY reset driver, it (1) won't fix
>> the root cause of the problem and (2) it won't fix all the other
>> consumers of GPIO lines which will also be reset.
>> 
>> It turns out, the Ocelot SoC has the same weird behavior (or the
>> lack of a dedicated switch reset) and there the problem is already
>> solved and all the bits and pieces are already there and this PHY
>> reset property isn't not needed at all.
>> 
>> There are no users of this binding. Just remove it.
> 
> Seems there was 1 user:
> 
> /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.example.dtb:
> switch@e0000000: resets: [[4294967295, 0], [4294967295, 0]] is too
> long
>  From schema:
> /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.example.dtb:
> switch@e0000000: reset-names: ['switch', 'phy'] is too long
>  From schema:
> /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> 
> Please fix as this is now failing in linux-next.

Sorry. Should be fixed with
https://lore.kernel.org/netdev/20220503132038.2714128-1-michael@walle.cc/

-michael
