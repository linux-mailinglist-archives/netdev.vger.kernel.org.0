Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B55A3B2C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfH3QAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 12:00:40 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35247 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfH3QAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 12:00:39 -0400
Received: by mail-yb1-f194.google.com with SMTP id c9so2647523ybf.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 09:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AnJOwPGndzf2b8FTXaxhouQZ9Q24A7TzncK0ESBDPNU=;
        b=M6GD6Mkq83F9RN5LE8jyPQBwtIGTbg1WuOjno71wiTgRmaWgA5rfknp7aXQlB0Vue6
         NoxIczyQXMel1VkyjndKMmBc6IonbQYoEEpH+Ef0530hh6az+Fg1BpiSg915mq5hn2gb
         mHXHkWre4DSvdPyr8ElOeg5LE2iRYuMUL+C/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AnJOwPGndzf2b8FTXaxhouQZ9Q24A7TzncK0ESBDPNU=;
        b=Vnz+50zIPS3kbz/kBmREp61hVnVSCBd14LRo9Ln5rAFaD8VQhnxYuUK9CPaOB0wIsc
         ibSZuuTLOAq+mHzelzozWTHgGDZccpDEB9P76VfXefbFm8WzANbYuMx2jNo7Fay3oNjH
         JLb8JgouqJEKOLSp2y4gmJBcNvS3+CIoOshWe78LcrMezBkJFkQCJwAK7aeFqL1uNlMY
         Y9eP9OTCcS7Q+wSEezxgy6Yh4wl3pzJSsfKr7GQGBHlD4pBpaXL4xjboBO0g35Cic40E
         IUcuMi4MBcWumCcOpt5jDMx9uihnWMK8ZvUyO1Xr6JnqwWHQRykBH3x8ld2qhvssDCU1
         SO/A==
X-Gm-Message-State: APjAAAV7Kf7Yd5jGOYm2slCRyEFHuwRULQTFUgpoaikUKYE8IfB7sg9V
        5uaBMIDAqwAzGRVdHIScWAirZmQJEGHVp8jBkx47tw==
X-Google-Smtp-Source: APXvYqyO6ksQDqHkkDyTNpum+1yOd/jN45mVk7UZY8nswEXfXha+kNx0Xv6xOteFA7sx3KDNXOCh0sYEIGTm4iYBF5k=
X-Received: by 2002:a25:3557:: with SMTP id c84mr11355530yba.298.1567180838869;
 Fri, 30 Aug 2019 09:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
 <20190826060045.GA4584@mtr-leonro.mtl.com> <20190830091838.GC12611@unreal>
In-Reply-To: <20190830091838.GC12611@unreal>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 30 Aug 2019 09:00:27 -0700
Message-ID: <CACKFLiku-5Q6mBFgd2L_gTqZ=UWUf_HTUeC_n6=aVH+V_o1p4g@mail.gmail.com>
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, Ray Jui <ray.jui@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 2:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Aug 26, 2019 at 09:00:45AM +0300, Leon Romanovsky wrote:
> > On Sun, Aug 25, 2019 at 11:54:54PM -0400, Michael Chan wrote:
> > > Refactor the hardware/firmware configuration portion in
> > > bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
> > > new function can be called after a firmware reset to reconfigure the
> > > VFs previously enabled.
> >
> > I wonder what does it mean for already bound VFs to vfio driver?
> > Will you rebind them as well? Can I assume that FW error in one VF
> > will trigger "restart" of other VFs too?
>
> Care to reply?
>
>
Sorry, I missed your email earlier.

A firmware reset/recovery has no direct effect on a VF or any function
if it is just idle.  The PCI interface of any function does not get
reset.

If a VF driver (Linux VF driver, DPDK driver, etc) has initialized on
that function, meaning it has exchanged messages with firmware to
register itself and to allocate resources (such as rings), then the
firmware reset will require all those resources to be re-discovered
and re-initialized.  These VF resources are initially assigned by the
PF.  So this refactored function on the PF is to re-assign these
resources back to the VF after the firmware reset.  Again, if the VF
is just bound to vfio and is idle, there is no effect.
