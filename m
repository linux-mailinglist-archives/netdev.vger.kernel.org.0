Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B823665D772
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbjADPo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbjADPoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:44:05 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2851321B7;
        Wed,  4 Jan 2023 07:44:04 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so83368683ejc.3;
        Wed, 04 Jan 2023 07:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IIaEuuy3hezBPSUU67x/AgMenS8vgS8r+KGoEFWjtjI=;
        b=Gkf7jpqhmyycDguXxWr2LR5nLm41fIGgEfy1iVQrnxBy+Lr6WNsVzqVCfUbPoEqP5/
         oxC15tEnITTJN4miuvJTTMe+aLiSTsQMIiey1W1EeSPymIXYarQ2KbErT5Oh8c3v3e7i
         QbNIAmb3SsjRwN0WeV5l4UoL/NFuO7lkHJvkNYETYt3cNlpiSGu9BHtPLJF0HSVJHwtd
         mUWKAfnNMCoZEcX7jCYN34qXyzi9WEgcfjhwlQKujlzoRo+B0MDM+MF0dLuHH/hoUFbT
         BqrMxd4MxQ56Ea58VemAfMHCn6vk3T0zJDk6H4FDqNA4fApxb7pI607UaDBdsMYjHqLx
         NbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIaEuuy3hezBPSUU67x/AgMenS8vgS8r+KGoEFWjtjI=;
        b=LcaFIv5Nl1jDbNw3SymvfOwu5dYnQlg/J3yYJft9XxgyNuRsdSpCB5iniqn7Fxjy8n
         V9AhZ8cz9eWqDrJUPuj3A/4yKwi6T84bIBmBLFpZhlgzM2/mhefoEzy8wq4cshdkM4fR
         et1dIzt4T+nIY24nbCh7BEqAJ+oqC8+cYbxZOrCjAncII6mLXIRHTurIFq8hgghxUKmE
         s9IVGbJEHDgiOqQgNRSl4KpMXLll8T4CKBpXZwCAdV+E6GdfofZyxDQjvTrgZtXPmoY4
         rl46qRJHBg6NrLx50qVHGXhgcChpJmQq+fJwzV8gnPHWWe+49GiRJpZ/0mp2NrjHD+Vx
         aSJw==
X-Gm-Message-State: AFqh2kpy41WxuT23gPkVJnM0NIclb6YJumJOSMLQCkx4SKNwfgYxmCqq
        xAwXPhWPTtMaQD5CCKwwOJKh5tmgR60h0XUXoD4=
X-Google-Smtp-Source: AMrXdXuw8H4Uw+kNus0+1L7mtR8Mph4HV6zSENV6emLTtORiTo8ZBgL5HA9jFO/jy3cPxYrrv1NdbDUK5+Ma6rCGFqw=
X-Received: by 2002:a17:906:81cf:b0:7c1:6b9e:6f5d with SMTP id
 e15-20020a17090681cf00b007c16b9e6f5dmr4140124ejx.339.1672847043436; Wed, 04
 Jan 2023 07:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
 <20221229124845.1155429-3-martin.blumenstingl@googlemail.com> <70d276b911fbf3d77baf2fbd7d5a8716a01f6c2a.camel@realtek.com>
In-Reply-To: <70d276b911fbf3d77baf2fbd7d5a8716a01f6c2a.camel@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 16:43:52 +0100
Message-ID: <CAFBinCD-ygjiGuqMgHEBjfr_U67JrqHE7oxNGvT5zhCtgetK7g@mail.gmail.com>
Subject: Re: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc()
 outside the RCU lock
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Fri, Dec 30, 2022 at 12:48 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
> > Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> I think my reviewed-by should behind your signed-off-by.
My understanding is that I have to put your Reviewed-by above my
Signed-off-by since I added the Reviewed-by to the description.
If the maintainer adds your Reviewed-by while applying the patch to
the tree they will put your Reviewed-by between my Signed-off-by and
the maintainer's Signed-off-by.

If this is incorrect then please let me know and I'll change it for v3.


Best regards,
Martin
