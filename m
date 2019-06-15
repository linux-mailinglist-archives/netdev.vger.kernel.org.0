Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB43D47048
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfFOOHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:07:17 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42776 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOOHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:07:17 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so5124034lje.9
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 07:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovPHhf9j65gQ+qwvLBT1v8tkpoDxIhQD9VAxiFNe3AE=;
        b=LDbZQPheHxrq2vERKq9mMfFGShX2v5/+5MQEAQhGZ1h1tJ4hOYM9/OIfnVNV/gR3kT
         xlwWAYvpGPb/XbxCgFqIFio1USiRhJaGEOndE+tPH0prmT+E9EN5KzNU/a4C1Q7m2rCj
         Bv3OwTpS1Jx1z4NSTyYNUpAMuhiqvzeFkjUmFAwjZbB9+t/O0cRZnC/bh/o7I/uE7tp9
         4r8Sm7cI2JxaZgA5E5yO0DlUNqiRxXUqZ5/R/15qnSHroJLpbu2+dWohEXMuzgaITKoz
         Z+5VY2arYiUadNw1AXM1V4MVY8/ysZij/xtyvmOexSK9S1cbFlprnVPNAYeNVwL0z/MA
         P8QA==
X-Gm-Message-State: APjAAAVIE4o82ZP1mf+MGMWvrTbJ4sGwq9dYof64jdUYxIRTJS/rC3lU
        epb+y0GGaHr3odyNqvF5tRwEPZkbNyGX3Zz2miJI7w==
X-Google-Smtp-Source: APXvYqxH2XxffNa43+qGLnA0UA7PyUkkddaTkMBTRbtOGFzaFyGDOL0dl9fIhup6PvoOSwQWC6U9uvIhhZGhq8rHinM=
X-Received: by 2002:a2e:3013:: with SMTP id w19mr41923974ljw.73.1560607635021;
 Sat, 15 Jun 2019 07:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190611161031.12898-1-mcroce@redhat.com> <11cdc79f-a8c9-e41f-ac4d-4906b358e845@gmail.com>
In-Reply-To: <11cdc79f-a8c9-e41f-ac4d-4906b358e845@gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 15 Jun 2019 16:06:38 +0200
Message-ID: <CAGnkfhwH-4+Ov+QRBZaQaHnnbTczpavuV8_yJBg=GOHSLD0pQw@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:36 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/11/19 10:10 AM, Matteo Croce wrote:
> > Refactor the netns and ipvrf code so less steps are needed to exec commands
> > in a netns or a VRF context.
> > Also remove some code which became dead. bloat-o-meter output:
> >
>
> This breaks the vrf reset after namespace switch
>
>
> # ip vrf ls
> Name              Table
> -----------------------
> red               1001
>
> Set shell into vrf red context:
> # ip vrf exec red bash
>
> Add new namespace and do netns exec:
> # ip netns  add foo
> # ./ip netns exec foo bash
>
> Check the vrf id:
> # ip vrf id
> red
>
> With the current command:
> # ip netns exec foo bash
> # ip vrf id
> <nothing - no vrf bind>

Hi David,

if the vrf needs to be reset after a netns change, why don't we do in
netns_switch()?
This way all code paths will be covered.

Cheers,
-- 
Matteo Croce
per aspera ad upstream
