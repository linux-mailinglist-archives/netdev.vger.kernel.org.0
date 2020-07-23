Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9E22A6D1
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGWFPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgGWFPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 01:15:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22335C0619DC;
        Wed, 22 Jul 2020 22:15:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so4954797lji.9;
        Wed, 22 Jul 2020 22:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iK9ZJln7Y3yUAQuaOBlrVH/Nk3SxnEiqC2v1h/7xv4=;
        b=cOIE6WtI7i4MGEcYmS3wgwtBaJqrdVJiTH8BmoKgivLT/p6pQNo6p+eFvFFyIlvdcG
         sY5ZxZKz3W89T/4Sp4qyrdZrdlcsmb+Mpbwn9JuDhB+Gzh5yWJq85rsLinBd2wHkzv1S
         CvZ60YFGHBfjhhaSHb7zUU8cFjOfgzjEllU6ltv8oJokUpwlqg2u8FWLDjMY9OVEnzIb
         fwA9kkM4qybpZx2FrZSPsvnBChotlbMfstdcj9BogkSnPwNrIdiE3tSko4zm9/s1WkMu
         dSfno+x854d+RSuC99bMZryVycSawNAwYRiUgI19ZxUj4PrjW9UXowZitD2GspObSlP3
         EGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0iK9ZJln7Y3yUAQuaOBlrVH/Nk3SxnEiqC2v1h/7xv4=;
        b=EHwsT5MfcRlfTQrkUVvgSWqlG7+wYiBy5ay8cDZGqLDEMdf5TY87DVtWLsD7hpSnw7
         miLWsmpzCaKJKldhE6ggJEFVyhLBJxLZ2cTpoZflmKWk2/tKQTBHXVwbKx6Jt5oxTKKD
         dj6gbwm0r98BLpGKba3sAtFOWydFCSM+WWFU8iT3x45hLBYwfsG6lpfX7EBdL7iFWEEe
         EYD7TrPMfF6fHwudVjYYP5YPIsp3h/vMlVC0i33zdbITsCGmOlvm75dRu+JhvJDjG8T4
         Cqh9ZK2ahj+ZQ2Kd7JUZ3wdQ+jcr6MFVVv0186+LYbT9jQhYotn93TurPMyngqTx7i4g
         upcw==
X-Gm-Message-State: AOAM530D4J/M1Gr2Vug1MrC/mQqqpC/MLMui0UHExe5vo76Pi1ZBnImX
        OZQ6OoQ07OnioHSHbDuTUfAsWiTmnOpuxk14OJVNbQ==
X-Google-Smtp-Source: ABdhPJx1v6qF8/dsa9w3TmOfhTg4eNTp4lcS87wu/Ep1b4LYkVzPLX7fpxUyk5Yun5sdQyJ/uapiHCaEDQ2EBXkzAEE=
X-Received: by 2002:a2e:90da:: with SMTP id o26mr1172349ljg.91.1595481322609;
 Wed, 22 Jul 2020 22:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200722161720.940831-1-jakub@cloudflare.com> <20200722165902.51857-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200722165902.51857-1-kuniyu@amazon.co.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jul 2020 22:15:11 -0700
Message-ID: <CAADnVQ+ni+n-1T2Ls-cLx7Hj20PVSAWF754x4VzwoWcW8nxZ5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Fix BPF socket lookup with reuseport groups
 with connections
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 9:59 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Jakub Sitnicki <jakub@cloudflare.com>
> Date:   Wed, 22 Jul 2020 18:17:18 +0200
> > This mini series contains a fix for a bug noticed when analyzing a reported
> > merge conflict between bpf-next and net tree [0].
> >
> > Apart from fixing a corner-case that affects use of BPF sk_lookup in tandem
> > with UDP reuseport groups with connected sockets, it should make the
> > conflict resolution with net tree easier.
> >
> > These changes don't replicate the improved UDP socket lookup behavior from
> > net tree, where commit efc6b6f6c311 ("udp: Improve load balancing for
> > SO_REUSEPORT.") is present.
> >
> > Happy to do it as a follow up. For the moment I didn't want to make things
> > more confusing when it comes to what got fixed where and why.
> >
> > Thanks,
> > -jkbs
>
> Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Applied to bpf-next. Thanks
