Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CCD69E79
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 23:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfGOVop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 17:44:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41953 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731858AbfGOVop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 17:44:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id o101so18695714ota.8;
        Mon, 15 Jul 2019 14:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hO2lc5/RCrOfroO8+pzsn6ZrqRVw3tFQDoLgNfzmBUQ=;
        b=QxXDGZ3v64gyAMTDqUN0aDnOZUEUriuNBjPSYo18FhopZ8P0hjPzAG+ZIKn7zH4gUi
         QQfKwc35vqrWxz9Pdos45CbPkxluZAY+xJxiCUnS/c8V3irYv3sVlFOGVsI03FOmIaXv
         1EW+EKfby2IgVifnLuY8yMlV3B9g9zSRWk+MkjD42FojhmDrPbL1Gj05OvCQfmBMrtVC
         H2sgMK8MwEiq61UuGNkJPV+VQ+plnLtUXI5O8yARGzjtU/JH3OxAdhS+CBaJnz7jEarF
         rKc52Lygct/0tLMNo/N1pP0Qx0Vim/zzGg889XPO1TWBw/bRbhAqCy7vbi3fogYK9Wkn
         2OSA==
X-Gm-Message-State: APjAAAUsAOkRYO87kbLMCwaOxid9BCDbmnB2OvJG6nh20Bt2jxK632To
        Re3Z9R3uMSLoWgU/fV0rp3nL8QXeSGq3NMcP2Ik=
X-Google-Smtp-Source: APXvYqxeBU+lL3PSYmxhb7JppIVz9aT6KKyGzUIDEJ8gGEzipFV4PQx8sL/9KU3ERl8XEJvsrjqZy4/vHGyUSxfUvR0=
X-Received: by 2002:a05:6830:1516:: with SMTP id k22mr18941426otp.189.1563227084317;
 Mon, 15 Jul 2019 14:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190715143705.117908-1-joel@joelfernandes.org> <20190715143705.117908-9-joel@joelfernandes.org>
In-Reply-To: <20190715143705.117908-9-joel@joelfernandes.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 15 Jul 2019 23:44:31 +0200
Message-ID: <CAJZ5v0jdx1dgBZLyH_Loj1XVuLCV+HMHjk8r_n8xG7qmoH_z3A@mail.gmail.com>
Subject: Re: [PATCH 8/9] acpi: Use built-in RCU list checking for
 acpi_ioremaps list (v1)
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        NeilBrown <neilb@suse.com>, netdev <netdev@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 4:43 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it for acpi_ioremaps list traversal.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/osl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9c0edf2fc0dd..2f9d0d20b836 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include <linux/lockdep.h>
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <linux/kmod.h>
> @@ -80,6 +81,7 @@ struct acpi_ioremap {
>
>  static LIST_HEAD(acpi_ioremaps);
>  static DEFINE_MUTEX(acpi_ioremap_lock);
> +#define acpi_ioremap_lock_held() lock_is_held(&acpi_ioremap_lock.dep_map)
>
>  static void __init acpi_request_region (struct acpi_generic_address *gas,
>         unsigned int length, char *desc)
> @@ -206,7 +208,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>  {
>         struct acpi_ioremap *map;
>
> -       list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +       list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>                 if (map->phys <= phys &&
>                     phys + size <= map->phys + map->size)
>                         return map;
> @@ -249,7 +251,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
>  {
>         struct acpi_ioremap *map;
>
> -       list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +       list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>                 if (map->virt <= virt &&
>                     virt + size <= map->virt + map->size)
>                         return map;
> --
> 2.22.0.510.g264f2c817a-goog
>
