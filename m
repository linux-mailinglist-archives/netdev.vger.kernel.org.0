Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5568E2D134D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLGON4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 09:13:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34379 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgLGONz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 09:13:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id k14so12924787wrn.1;
        Mon, 07 Dec 2020 06:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gG7VgUZtjX4oofV7gBPwji7WUqiGnJQzMVNQgM8p0KI=;
        b=ezMlb7Ga7t9M6AwPYfev/SUnfIJ/AEYtRJXq83YANQloZMdCxp+MGh2kGCIKh6E0JY
         mM1ufDMlyE5NipQVqgd2FNbKsA9ZewCZ0iD8g0JavMnE0Lz7hOlcO1ah/GR1Zv4DEg0l
         i+sHlJmFGgfygdfJyFEJPCvEhkJjg/7NZvfyDFVE0bbVfBsoMF4W7mW6JfVmWl3DrWmb
         e9CcYiPvT0Ra399/apuhY405v4cRBIx21HYMl7XSvbOtSIJfoMAZyJ8mbWcl0PUtMK8x
         YFXRh+CuRhC9rWCmNmldyDc6P92Y6vttL+Ej5FMFjiCS5Gs07Q5OOxxGl6FNYmGk08Ec
         120w==
X-Gm-Message-State: AOAM532/xDX/JEew6rYFJjl07elYif6K/D9IfNNHPS29JBp/AoRNR20i
        QhrD16uauq2kv9Q6WpXfvUw=
X-Google-Smtp-Source: ABdhPJyDGmRg/7pSYaUY4kTpP3/w8YFZ21qsd0KTsX0+bqFdeH6YXibx9gEqHimAS3PtvvVq5sh71w==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr19326981wrr.319.1607350393759;
        Mon, 07 Dec 2020 06:13:13 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z11sm15491704wmc.39.2020.12.07.06.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:13:12 -0800 (PST)
Date:   Mon, 7 Dec 2020 15:13:11 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Change irqflags
Message-ID: <20201207141311.GB34599@kozik-lap>
References: <20201207113827.2902-1-bongsu.jeon@samsung.com>
 <20201207115147.GA26206@kozik-lap>
 <CACwDmQDHXwqzmUE_jEmPcJnCcPrzn=7qT=4rp1MF3s30OM7uTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACwDmQDHXwqzmUE_jEmPcJnCcPrzn=7qT=4rp1MF3s30OM7uTQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 10:39:01PM +0900, Bongsu Jeon wrote:
> On Mon, Dec 7, 2020 at 8:51 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Mon, Dec 07, 2020 at 08:38:27PM +0900, Bongsu Jeon wrote:
> > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > >
> > > change irqflags from IRQF_TRIGGER_HIGH to IRQF_TRIGGER_RISING for stable
> > > Samsung's nfc interrupt handling.
> >
> > 1. Describe in commit title/subject the change. Just a word "change irqflags" is
> >    not enough.
> >
> Ok. I'll update it.
> 
> > 2. Describe in commit message what you are trying to fix. Before was not
> >    stable? The "for stable interrupt handling" is a little bit vauge.
> >
> Usually, Samsung's NFC Firmware sends an i2c frame as below.
> 
> 1. NFC Firmware sets the gpio(interrupt pin) high when there is an i2c
> frame to send.
> 2. If the CPU's I2C master has received the i2c frame, NFC F/W sets
> the gpio low.
> 
> NFC driver's i2c interrupt handler would be called in the abnormal case
> as the NFC F/W task of number 2 is delayed because of other high
> priority tasks.
> In that case, NFC driver will try to receive the i2c frame but there
> isn't any i2c frame
> to send in NFC. It would cause an I2C communication problem.
> This case would hardly happen.
> But, I changed the interrupt as a defense code.
> If Driver uses the TRIGGER_RISING not LEVEL trigger, there would be no problem
> even if the NFC F/W task is delayed.

All this should be explained in commit message, not in the email.

> 
> > 3. This is contradictory to the bindings and current DTS. I think the
> >    driver should not force the specific trigger type because I could
> >    imagine some configuration that the actual interrupt to the CPU is
> >    routed differently.
> >
> >    Instead, how about removing the trigger flags here and fixing the DTS
> >    and bindings example?
> >
> 
> As I mentioned before,
> I changed this code because of Samsung NFC's I2C Communication way.
> So, I think that it is okay for the nfc driver to force the specific
> trigger type( EDGE_RISING).
> 
> What do you think about it?

Some different chip or some different hardware implementation could have
the signal inverted, e.g. edge falling, not rising. This is rather
a theoretical scenario but still such change makes the code more
generic, configurable with DTS. Therefore trigger mode should be
configured via DTS, not enforced by the driver.

Best regards,
Krzysztof
