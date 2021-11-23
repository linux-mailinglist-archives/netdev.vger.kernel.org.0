Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988E045B082
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbhKWX47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:56:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:50219 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhKWX45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 18:56:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="321397703"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="321397703"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 15:53:48 -0800
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="509610560"
Received: from pshinde-mobl.amr.corp.intel.com ([10.213.85.70])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 15:53:41 -0800
Message-ID: <c5d1ee1f3b59bf18591a164c185650c77ec8aba7.camel@linux.intel.com>
Subject: Re: [PATCH v2 12/63] thermal: intel: int340x_thermal: Use
 struct_group() for memcpy() region
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Date:   Tue, 23 Nov 2021 15:53:38 -0800
In-Reply-To: <CAJZ5v0iS3qMgdab1S-NzGfeLLXV=S6p5Qx8AaqJ50rsUngS=LA@mail.gmail.com>
References: <20210818060533.3569517-1-keescook@chromium.org>
         <20210818060533.3569517-13-keescook@chromium.org>
         <CAJZ5v0iS3qMgdab1S-NzGfeLLXV=S6p5Qx8AaqJ50rsUngS=LA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-23 at 14:19 +0100, Rafael J. Wysocki wrote:
> On Wed, Aug 18, 2021 at 8:08 AM Kees Cook <keescook@chromium.org>
> wrote:
> > 
> > In preparation for FORTIFY_SOURCE performing compile-time and run-
> > time
> > field bounds checking for memcpy(), avoid intentionally writing
> > across
> > neighboring fields.
> > 
> > Use struct_group() in struct art around members weight, and ac[0-
> > 9]_max,
> > so they can be referenced together. This will allow memcpy() and
> > sizeof()
> > to more easily reason about sizes, improve readability, and avoid
> > future
> > warnings about writing beyond the end of weight.
> > 
> > "pahole" shows no size nor member offset changes to struct art.
> > "objdump -d" shows no meaningful object code changes (i.e. only
> > source
> > line number induced differences).
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Amit Kucheria <amitk@kernel.org>
> > Cc: linux-pm@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Rui, Srinivas, any comments here?
Looks good.
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Thanks,
Srinivas

> 
> > ---
> >  .../intel/int340x_thermal/acpi_thermal_rel.c  |  5 +-
> >  .../intel/int340x_thermal/acpi_thermal_rel.h  | 48 ++++++++++-------
> > --
> >  2 files changed, 29 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> > b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> > index a478cff8162a..e90690a234c4 100644
> > --- a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> > +++ b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
> > @@ -250,8 +250,9 @@ static int fill_art(char __user *ubuf)
> >                 get_single_name(arts[i].source,
> > art_user[i].source_device);
> >                 get_single_name(arts[i].target,
> > art_user[i].target_device);
> >                 /* copy the rest int data in addition to source and
> > target */
> > -               memcpy(&art_user[i].weight, &arts[i].weight,
> > -                       sizeof(u64) * (ACPI_NR_ART_ELEMENTS - 2));
> > +               BUILD_BUG_ON(sizeof(art_user[i].data) !=
> > +                            sizeof(u64) * (ACPI_NR_ART_ELEMENTS -
> > 2));
> > +               memcpy(&art_user[i].data, &arts[i].data,
> > sizeof(art_user[i].data));
> >         }
> > 
> >         if (copy_to_user(ubuf, art_user, art_len))
> > diff --git a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> > b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> > index 58822575fd54..78d942477035 100644
> > --- a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> > +++ b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.h
> > @@ -17,17 +17,19 @@
> >  struct art {
> >         acpi_handle source;
> >         acpi_handle target;
> > -       u64 weight;
> > -       u64 ac0_max;
> > -       u64 ac1_max;
> > -       u64 ac2_max;
> > -       u64 ac3_max;
> > -       u64 ac4_max;
> > -       u64 ac5_max;
> > -       u64 ac6_max;
> > -       u64 ac7_max;
> > -       u64 ac8_max;
> > -       u64 ac9_max;
> > +       struct_group(data,
> > +               u64 weight;
> > +               u64 ac0_max;
> > +               u64 ac1_max;
> > +               u64 ac2_max;
> > +               u64 ac3_max;
> > +               u64 ac4_max;
> > +               u64 ac5_max;
> > +               u64 ac6_max;
> > +               u64 ac7_max;
> > +               u64 ac8_max;
> > +               u64 ac9_max;
> > +       );
> >  } __packed;
> > 
> >  struct trt {
> > @@ -47,17 +49,19 @@ union art_object {
> >         struct {
> >                 char source_device[8]; /* ACPI single name */
> >                 char target_device[8]; /* ACPI single name */
> > -               u64 weight;
> > -               u64 ac0_max_level;
> > -               u64 ac1_max_level;
> > -               u64 ac2_max_level;
> > -               u64 ac3_max_level;
> > -               u64 ac4_max_level;
> > -               u64 ac5_max_level;
> > -               u64 ac6_max_level;
> > -               u64 ac7_max_level;
> > -               u64 ac8_max_level;
> > -               u64 ac9_max_level;
> > +               struct_group(data,
> > +                       u64 weight;
> > +                       u64 ac0_max_level;
> > +                       u64 ac1_max_level;
> > +                       u64 ac2_max_level;
> > +                       u64 ac3_max_level;
> > +                       u64 ac4_max_level;
> > +                       u64 ac5_max_level;
> > +                       u64 ac6_max_level;
> > +                       u64 ac7_max_level;
> > +                       u64 ac8_max_level;
> > +                       u64 ac9_max_level;
> > +               );
> >         };
> >         u64 __data[ACPI_NR_ART_ELEMENTS];
> >  };
> > --
> > 2.30.2
> > 


