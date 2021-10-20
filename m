Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10001434868
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhJTJ7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhJTJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:59:24 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58951C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:57:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b188so18914399iof.8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pcKdTOkR/GZDEmuSn4ASMp6zAcofYzOxflxOqSu54Oc=;
        b=pm0fpYdpR7I6voVoXZMrSCsBruZhzXQPDxSgnDDvr6g3sIvG15ViHq8N4sJkzJfFwa
         w1s7RkdC7ZgPwNXpB5cCcQfKJVARxHJ7RAdCIrHPmC59oTjziufu2FBqLa4ztYP55UwJ
         g2vrmj+f74oqjFmbjr66CIC24oTSyIjGuZn6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pcKdTOkR/GZDEmuSn4ASMp6zAcofYzOxflxOqSu54Oc=;
        b=lbeWwqSiJFQuo/ZKIfnI056vBZ1Ho9zz/cpX0nTH9w38Bped+SIi6qxjgAHVFK+T7z
         IGgLfo6cfcOPr47z05sUYEkigiv2sW7fkyE4T1HXJNt30326wJxdTQ6d6Q24EEKlxjKj
         1UctwX5ATdD4VHfRyM/tu0xXBQVXcK6zO9tGhGBnTZ/1ZSi/wNyKjhcIz0X6pfi2nPgT
         8IJHMST5pTIS8CWBLhOZZyYFKwv/v7i+S7WRZWkHQcf810IZ4NssVpj7nzVnFR4Olf5P
         4lQc3p8+oYI9juU895l8oki1jKeL0QZ2JHGRG8rmt0xtibyF+07LNqVcpn1bVwkAThN7
         swAA==
X-Gm-Message-State: AOAM531sTBYuWUa1hQTuFXMBaYydqHda6Vt8ZYjMbkmxE0TAVl9d0qIe
        EHM27A3/NjsX0M33SGXqlZqUnx2fUGY9MA==
X-Google-Smtp-Source: ABdhPJz0OQoa2Mri5JaANHov+KjukRphqSKzpaYKbVIY4O085lIYROKMUupE5TPXEOPN0HXvgB/M8g==
X-Received: by 2002:a02:c65a:: with SMTP id k26mr8060036jan.29.1634723829551;
        Wed, 20 Oct 2021 02:57:09 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id z16sm838652iow.42.2021.10.20.02.57.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Oct 2021 02:57:09 -0700 (PDT)
Date:   Wed, 20 Oct 2021 09:57:07 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Retrieving the network namespace of a socket
Message-ID: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm working on a problem where I need to determine which network namespace a 
given socket is in. I can currently bruteforce this by using INET_DIAG, and 
enumerating namespaces and working backwards. 

I was wondering if anyone had any suggestions on where to add this capability, 
or suggestions how on how it might look? It appears like using network namespace 
IDs is the thing to do -- I'm unsure of whether this API fits better into 
ioctl_ns, getsockopt, netlink, or even somewhere in proc. I'm curious what 
people think. I think that the "easiest" way would be to drop it into fdinfo
in proc.

Alternatively, I may have overlooked an existing API.

-Thanks,
Sargun
