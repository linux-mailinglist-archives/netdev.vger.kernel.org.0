Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24192C8D61
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfJBPud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:50:33 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35982 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbfJBPud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:50:33 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so18095608oih.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 08:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XPi23PQ3ntrJN4vwnFwOV3iiejI/uiaQJJXoux+ak0I=;
        b=eHNq+x9e3grDWF9FADg+Uq3zpxAVrmz2HUc0eGIZ3zLPLUWCLWzi3PbAQvJi5x81bs
         XaN+SLrQ3ocESNPArhR9QE3cmg8CA7ofNnK2hDevrtkotdEX932qSEdagljwVCN1/oCC
         GsoRTSoLVr3ZVMzblw58nd8gPaKIAhwanYgVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XPi23PQ3ntrJN4vwnFwOV3iiejI/uiaQJJXoux+ak0I=;
        b=iTZCEOUA9fyS0x+uYX9Y1c7I61nJM6fj8LT08Rn4WgHEN8q6M5vFR+406DBxM0UfDc
         JnHXTJPj8h7q9t0rqN7Y6q73Zf8TZL2I4z0mh3YAda8QmOM3avRnejof8X2jqhS8WWhM
         IC+uZ1RNlMPhi+zxp9g89sE1FS1gGNRBztwmkF35ELURBIRh8scBQ5suovoBWHUg6Bno
         d6k7RAzOzNmCeXqwH29Ss4lmbDFXG3ryP0gocq9syJiS3WBrxXydZozlGslW2eFR/QEk
         Kbszt4TerCvSGbrorOTHyO2MhGQizH+ci0rgGOSpdS7kReHaCAvqb/bRCFXBUJiMew+R
         PKpg==
X-Gm-Message-State: APjAAAUNx3eOi/ia91bNWOsRA0f4DuyWIx5KhVD1hXbVC1bG78TqF1LW
        nrULGrN6uFlq8EwhjTKouXiIxLLCqDOafJRPhRr9IQ==
X-Google-Smtp-Source: APXvYqzdQir8sEmBMINkIdrrlG7+jwPznL9m21FBsLaWxLZKLykHRd/1vLIB2wFQXhPNi8t6PJAjFkLARdQflSWiLVA=
X-Received: by 2002:aca:3556:: with SMTP id c83mr3277944oia.78.1570031431218;
 Wed, 02 Oct 2019 08:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <157002302784.1302756.2073486805381846919.stgit@alrua-x1>
In-Reply-To: <157002302784.1302756.2073486805381846919.stgit@alrua-x1>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 2 Oct 2019 16:50:18 +0100
Message-ID: <CACAyw9-vS7zC0dg-rqkt=hwWkKD-a=WvX92-apiD=wp9vSsGcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] xdp: Support setting and getting device
 chain map
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Oct 2019 at 14:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support to rtnetlink for setting and getting the per-device XDP
> chain map. The map is set by means of a new netlink attribute that contai=
ns
> a pointer to a BPF map of the XDP chain type. If such an attribute is
> included, it will be inserted into the struct net_device so that the XDP
> chain call code will pick it up on program execution.
>
> To prevent old userspace programs that do not understand the chain map
> attribute from messing up the chain call order, a netlink message with no
> chain map attribute set will be rejected if a chain map has already been
> installed.
>
> When installing a new chain call map, an XDP program fd must also be
> provided, otherwise the operation will be rejected.

Why is the program required? I kind of expected the chain call map
to override any program.

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
