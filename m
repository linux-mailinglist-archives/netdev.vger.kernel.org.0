Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16C654A947
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbiFNGPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiFNGPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:15:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436D3377CF;
        Mon, 13 Jun 2022 23:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6661CE182F;
        Tue, 14 Jun 2022 06:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AB6C3411B;
        Tue, 14 Jun 2022 06:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655187335;
        bh=vo5JOYkEPeFEWpKNIvUVh541SRQIp5YhW0KwaowC1TE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EN9q83UhlB8dhqZIow1gnV9jnq1wtW6JSaaGpbPQFx1jpcnu9pWLvl/Ot00hUA5wz
         RJUDzPVu8bhWqMOjbaytQW1tBJYkzaiO2R4EMYyE9ckYuS3TJxtiUfT5mbDe9FE1c6
         uCnE7cS3inwzREhYL1LOR1A45ULHJJOdk+G0r9iPi34UU7PHEBL0RlVOorQObAydno
         llQcgPxq3WUbPPzbiT6WQRGBehDIqXuO+7PSQVzpv9kJX4XnRLc6Femx/AAZXTsmEQ
         3M8pTbe1A94HsYPT5DMqRPpd0HLaZGpYlahy8IhzIBtdHB6LQx+SLGJWz0tXJ+d2rM
         vhZulZ2tLmKFA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
        <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
        <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
Date:   Tue, 14 Jun 2022 09:15:28 +0300
In-Reply-To: <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr> (Christophe
        JAILLET's message of "Mon, 13 Jun 2022 22:57:25 +0200")
Message-ID: <871qvrrcsf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> Le 13/06/2022 =C3=A0 22:02, Christian Lamparter a =C3=A9crit=C2=A0:
>> On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
>> <christophe.jaillet@wanadoo.fr> wrote:
>>>
>>> If an error occurs after a successful call to p54spi_request_firmware()=
, it
>>> must be undone by a corresponding release_firmware() as already done in
>>> the error handling path of p54spi_request_firmware() and in the .remove=
()
>>> function.
>>>
>>> Add the missing call in the error handling path and remove it from
>>> p54spi_request_firmware() now that it is the responsibility of the call=
er
>>> to release the firmawre
>>
>> that last word hast a typo:  firmware. (maybe Kalle can fix this in post=
).
>
> More or less the same typo twice in a row... _Embarrassed_

No worries, I can fix the typo.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
