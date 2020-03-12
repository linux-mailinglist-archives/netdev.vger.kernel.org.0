Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCD4183291
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgCLOOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:14:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41936 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgCLOOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:14:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id l21so4410483qtr.8
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGOWEzuFvAFHZ+TtKYXzevHS7spI0ttzQWM3Fs5jjN0=;
        b=XrV1t4i4taWWnlcdwuM6/S7hlul/9g9iJbQyYvJPJeB+xcov3A+lQbQN/E8H5Nq3D/
         N5rFmuRiK6S0BIEnUilyXROLGowy8Vywapfz+f5H93geuE07P8jKmVmc1G3qTMf4HPmx
         bbWYVxHYEtO3d44ZOz+kDXLXHYvqAvtDVgcar+uxjkoYCgIMs/hY/dHZIahxtUVCKri4
         GA/t+CvLFl2nNMkxJ7q1/1nbSIpuWe7/vvdO56nnL5FcnjVPByVxoTJhUWpz+bEe0uMv
         tdWwJWlhjH1TdPGdx7kYnjukPRgsnUexK8gVFXjuA5OgfprB9lgNHc0YfGmw9fGqWn6H
         HYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGOWEzuFvAFHZ+TtKYXzevHS7spI0ttzQWM3Fs5jjN0=;
        b=JbTQzvy5VOTtkwIytXHnBIaTzMawMUrIhbXlRE9akTw5AD4eFPnpuEDyMroa5NxZNG
         n1e44oF/XHgt/c5nSCR3Up+Cg/ZzvgT+LwMrt5YmKYWrLH3O9/ox4srTzpxWAogYgBEB
         Np7GPlkGhLWsr4/DvfMW4DBfN1OcIV8HkNo4WZGBunqXjBhzyfxqEENKgGI8GOSaVuOi
         Emp+ucTlPqc/TKVujUWZmW09YkVOEy6ToF1k4Vjni23n0sA7Y3FytWcW0NTmXpCzTUtE
         6/UDcrgdt6GYaB12/R2V+mD+TnaQOWWHzg3K6M77F/Dt3kCfisuTvgqiUw2AUcHo+6E5
         2roQ==
X-Gm-Message-State: ANhLgQ11xWgEmcs9dLVfGWmhvtGr2SG8xRK4dtMrwY+X0mziRXhQGX61
        Z+cK+Rd2W9kr49m9WR/7Av6ZwEI8cBSqQzRBFsebUiwy
X-Google-Smtp-Source: ADFU+vtFXeAfKzbLJweYjp3yvcsrrDVX6miav3YFQjWXM8tJmyFEd1bua2RY8F5EJFNZv7Gxn/Yck3xA9pI2sNhOBKw=
X-Received: by 2002:ac8:76d7:: with SMTP id q23mr7470220qtr.198.1584022457434;
 Thu, 12 Mar 2020 07:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com> <20200311.234530.105958086242766446.davem@davemloft.net>
In-Reply-To: <20200311.234530.105958086242766446.davem@davemloft.net>
From:   Darell Tan <darell.tan@gmail.com>
Date:   Thu, 12 Mar 2020 22:14:08 +0800
Message-ID: <CAL20LWKM_yX4Dxjt6nxSosr5hTKmOi4eurGy1mCfw6hUUenprg@mail.gmail.com>
Subject: Re: [PATCH] net: phy: Fix marvell_set_downshift() from clobbering
 MSCR register
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 2:45 PM David Miller <davem@davemloft.net> wrote:
>
> From: Darell Tan <darell.tan@gmail.com>
> Date: Wed, 11 Mar 2020 22:41:38 +0800
>
> > Fix marvell_set_downshift() from clobbering MSCR register.
> >
> > A typo in marvell_set_downshift() clobbers the MSCR register. This
> > register also shares settings with the auto MDI-X detection, set by
> > marvell_set_polarity(). In the 1116R init, downshift is set after
> > polarity, causing the polarity settings to be clobbered.
> >
> > This bug is present on the 5.4 series and was introduced in commit
> > 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
> > helper"). This patch need not be forward-ported to 5.5 because the
> > functions were rewritten.
> >
> > Signed-off-by: Darell Tan <darell.tan@gmail.com>
>
> I don't see marvell_set_downshift() in 'net' nor 'net-next'.

This patch applies to the 5.4.x long term series and earlier, but not
to -stable or -next because the affected functions have already been
refactored.

Sorry I'm new to this. Should I be incorporating Andrew's comments and
sending a v2 to the linux-kernel list instead?

Thanks.
