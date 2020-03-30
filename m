Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642C7197CD9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgC3N0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:26:44 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:46858 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3N0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:26:44 -0400
Received: by mail-ed1-f53.google.com with SMTP id cf14so20538228edb.13
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=puxg/4POgOEA1rnQfYivGsvhCoB39/Gm6U/xas0Fn9w=;
        b=gOgiS4grg8d1bClPlxLjd6szQKOnbdHw3fqb3eN10formFZfQdNFZE6MSgKs7X8uc+
         +ph4yo8GsULvQkuHNihp9WudI8E0c8HE/vl1dW/Fsue1tP3BegLb3KJ1gBtscv9hTNCD
         F2BTBv8lYLwKYJ1q0LrEF/40Twc7k6mjYXxTr66t4QWfhToqbeC/l5HVj7VS3Geerd7m
         lRpk+eEcnALtkt2Na4fu9Z/FXvGuN9r+Puy7JT3ABaASExSy/hthYNvDxhIbWeNeUnSv
         ShWWJgWrNXmupFMpgwvnsC9q9ZK3U6WP+QBz/WxnJI8MtAcD6EEUoxvSxOfPywvNGSuf
         CPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=puxg/4POgOEA1rnQfYivGsvhCoB39/Gm6U/xas0Fn9w=;
        b=NW09QIFgNB4r2Ofcfmrx7lGHypSE1j2Z8TgYDxmUdxT4XOnY0p4MhMj7bk8NgP2EP7
         MnjGNEJLo+Jmd1vlZyuhrnQtCgynAiKufs76bQTxxXahreOQDpf0bbKpF3emYA2tHXao
         +4YNti5tchzFfy2MdioWW1WTzK22GGHMvGiCSKTjzpRJt2PztIlRw8j5LD8wi6Aq72NZ
         DqaaggJDhiBCwKtmw2OqnD3vFBdvZrTHLhP6jn/wtxS8wEmuMvFhGkISuJgIeSKMLEyD
         eqKqn+QeAjrffBdsCIkUYfRL1GzR3ey0QAgne7lHgFmS87IQm++bbHCg+hCyXCvzxjik
         cv/w==
X-Gm-Message-State: ANhLgQ2KLhQFeJJ5sLpN2JHiX9ucefqkPjuN23w0MJ8wzJKiNPKqRSYe
        v51PJl3PGU5KXwX5esklO1H0T1CeG98M+gSEowQ=
X-Google-Smtp-Source: ADFU+vuUELb6584wQnE3S1hgGpZig0/v0xkcZs8gLGAeMNuGS87ThzOO4G0kHR8ymdJFfslBCbchBAxOmYLHsiaeeiI=
X-Received: by 2002:a17:906:6bca:: with SMTP id t10mr10622452ejs.176.1585574801982;
 Mon, 30 Mar 2020 06:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
In-Reply-To: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 30 Mar 2020 16:26:30 +0300
Message-ID: <CA+h21hoeouAKH5Svp-aJj0oLrjH7DE=n1baTwa=Bwf5etAbjqg@mail.gmail.com>
Subject: Re: ingress rate limiting on mv88e6xxx
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 30 Mar 2020 at 16:23, Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> I'm trying to figure out what the proper way is to expose the ingress
> rate limiting knobs of the mv88e6250 (and related) to userspace. The
> simpest seems to be a set of sysfs files for each port, but I'm assuming
> that's a no-go (?)
>
> So what is the right way, and has anyone looked at hooking this up?
>
> Thanks,
> Rasmus

Does this give you any ideas?
https://patchwork.ozlabs.org/cover/1263417/

Regards,
-Vladimir
