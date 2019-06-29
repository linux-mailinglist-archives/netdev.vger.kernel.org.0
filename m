Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A655A8B1
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 05:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF2DqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 23:46:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46291 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfF2DqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 23:46:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so3900220pfy.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 20:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pgh5FexchZyJdC40RpW2zuB9tDz9wFaxoY4SP4BrWBo=;
        b=bhAzYPy2HF0BRM7XHVhdmcJ/NldDGZ7r4YBaghqiTHxX3DQIyD9f2NubZHfvkqwH2J
         9SvaSWJkSiW+gfLdQXvkhYXBdiMylOrXBoKewrqqKDEKlC5aBHo+hIt74ESkWVNQ4vY7
         PHiR8+dzVoMe7tyG5QCXRHVQ+RF2HYF0wxVu4HzSdGhSCjW9Dc7+m9YLxqtEg++xix1W
         tyKh0PrxrRGlyuNxOnUaokVxjpwGiXhBv510niWzRjgRAs8dNFqx/JTdGD5kU7bj/Tu1
         7+CzpgDQEp5DTEl+1LMcufYDlcnvOBA8uoO/YU+2S8QS05lguL3f6IEfM6WhAntJID+s
         bbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pgh5FexchZyJdC40RpW2zuB9tDz9wFaxoY4SP4BrWBo=;
        b=KKispcYISih3K+j95FLkli9a0tZmcCSLujBC/0KKs59xQ84bErpwMiOzxWhGLULxO4
         jrUpM2IMwEQ+rGHdMujLNwZFVs951D3ao3JCnYG01JDdKLN4WdkYJRfFfsZK9LfZY1ky
         Yiqb2CmG6JOi8aLpMe5zeN8MXbpxaSnr9EZIamNGNvg/YZrwXIFXRBliy1TC0RdpdiGI
         uHOAXNezqF4FujiDbZUxHBqwycSTMjW9f0m4AEHOHYvK/o2EPEwZHWNKfB6snY+30u/D
         dx/AIH+lx4qKSmie74ZQipD657J6JPdDXPWvIyqCXSa3GLNTdwgZ7dKPW8SnjpIRSnE9
         XNvA==
X-Gm-Message-State: APjAAAVKmyiYkf+/S9mOU9Ska+Igh1/po1y8kMz0UCVpH9j+al1WsdEr
        C2Ww3Dz+KwSMXPKoqysOQjLlX7Eaz38=
X-Google-Smtp-Source: APXvYqwj6nJGb1w+4EHwatDpROijZ/944UhqkYZYHX7yEz2yQNneZ3ekWcJZfpVSo2D1x3D+jHEHUg==
X-Received: by 2002:a17:90a:21ac:: with SMTP id q41mr17456985pjc.31.1561779967657;
        Fri, 28 Jun 2019 20:46:07 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o32sm3204394pje.9.2019.06.28.20.46.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 20:46:07 -0700 (PDT)
Date:   Fri, 28 Jun 2019 20:46:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Message-ID: <20190628204603.1191167b@cakuba.netronome.com>
In-Reply-To: <20190628175925.79a763f5@cakuba.netronome.com>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
        <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
        <20190627164402.31cbd466@cakuba.netronome.com>
        <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
        <20190628113100.597bfbe6@cakuba.netronome.com>
        <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
        <20190628154841.32b96fb1@cakuba.netronome.com>
        <5d16aec74b6cd_35a32adaec47c5c457@john-XPS-13-9370.notmuch>
        <20190628175925.79a763f5@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 17:59:25 -0700, Jakub Kicinski wrote:
> > > Sorry for all the questions, I'm not really able to fully wrap my head
> > > around this. I also feel like I'm missing the sockmap piece that may
> > > be why you prefer unhash over disconnect.   =20
> >=20
> > Yep, if we try to support listening sockets we need a some more
> > core infrastructure to push around ulp and user_data portions of
> > sockets. Its not going to be nice for stable. Also at least in TLS
> > and sockmap case its not really needed for any use case I know
> > of. =20
>=20
> IIUC we can't go from ESTABLISHED to LISTEN without calling close()=20
> or disconnect() so I'm not clear on why are we hooking into unhash() =F0=
=9F=98=95

Ah, disconnect() is also called with the socket already locked.
So no BH, but still not great..
