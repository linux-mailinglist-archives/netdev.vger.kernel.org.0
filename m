Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874292347B2
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgGaOZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 10:25:25 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37639 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbgGaOZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 10:25:25 -0400
Received: by mail-oi1-f195.google.com with SMTP id e6so6627474oii.4;
        Fri, 31 Jul 2020 07:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUq1ijDD9SyO2ufTXKPW9//vrm+uL0JQvV8OQ7tDtyA=;
        b=euny89LaKj/ti2o9A9iETv+dPKl7u/fbq7O0uhp3G4jRWPy2bhLjCCsj0j8ExW6UMQ
         H7u52fAfOLmEJP1TYyaXIyDsPptIjEQM6TNHWNcHfBQJEHQvi2BuBvwOY/oYdRdlWvV8
         54MU9pUGegIj14pgoWSnpA7FCcLiE1TFsSj9ODoxWoLdZ21aWFp3l/41whzoYOfzwwf+
         WmvJ0byILi3dqT+8S4BQS4L3Nl7SZF8B3PXcHLNu1h0bwY2TnWrhmL0oKRd7G/dMMVxp
         Iph+WUpF9ZmULJjI2WkVOciYmV9r20zlhfCiD/+F4x2Yp35o+g78jKzQLea3LK50i1m7
         wRlw==
X-Gm-Message-State: AOAM532Hd4NAG1/QXjDc4NI/VHEHG2+6ZYeeqYW0K+POuyP7CiPznUE9
        ejxgQIZGMG3GlT2LDDMv+mUN/gHWJw1B2GwIiwc=
X-Google-Smtp-Source: ABdhPJwXQdnG1otKOfzVxyL9Pv5KPx5Dv3MAzyWKLAJcQfKXU/RGMyj9PAedIsxXvXnE+QB4qD60adxhPMBESDi6fDY=
X-Received: by 2002:aca:a88e:: with SMTP id r136mr3259373oie.110.1596205523967;
 Fri, 31 Jul 2020 07:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com> <20200721000348.GA19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <408d3ce9-2510-2950-d28d-fdfe8ee41a54@oracle.com> <alpine.DEB.2.21.2007211640500.17562@sstabellini-ThinkPad-T480s>
 <20200722180229.GA32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007221645430.17562@sstabellini-ThinkPad-T480s>
 <20200723225745.GB32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007241431280.17562@sstabellini-ThinkPad-T480s>
 <66a9b838-70ed-0807-9260-f2c31343a081@oracle.com> <20200730230634.GA17221@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <53b577a3-6af9-5587-7e47-485be38b3653@oracle.com>
In-Reply-To: <53b577a3-6af9-5587-7e47-485be38b3653@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 31 Jul 2020 16:25:12 +0200
Message-ID: <CAJZ5v0j2kqgEfbiQchiA_USwGKC-UFkn2J3bUU2xCWU=+1p9Mw@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc:     Anchal Agarwal <anchalag@amazon.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        roger.pau@citrix.com, Jens Axboe <axboe@kernel.dk>,
        David Miller <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eduardo Valentin <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        xen-devel@lists.xenproject.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 4:14 PM Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
>
> On 7/30/20 7:06 PM, Anchal Agarwal wrote:
> > On Mon, Jul 27, 2020 at 06:08:29PM -0400, Boris Ostrovsky wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 7/24/20 7:01 PM, Stefano Stabellini wrote:
> >>> Yes, it does, thank you. I'd rather not introduce unknown regressions so
> >>> I would recommend to add an arch-specific check on registering
> >>> freeze/thaw/restore handlers. Maybe something like the following:
> >>>
> >>> #ifdef CONFIG_X86
> >>>     .freeze = blkfront_freeze,
> >>>     .thaw = blkfront_restore,
> >>>     .restore = blkfront_restore
> >>> #endif
> >>>
> >>>
> >>> maybe Boris has a better suggestion on how to do it
> >>
> >> An alternative might be to still install pm notifier in
> >> drivers/xen/manage.c (I think as result of latest discussions we decided
> >> we won't need it) and return -ENOTSUPP for ARM for
> >> PM_HIBERNATION_PREPARE and friends. Would that work?
> >>
> > I think the question here is for registering driver specific freeze/thaw/restore
> > callbacks for x86 only. I have dropped the pm_notifier in the v3 still pending
> > testing. So I think just registering driver specific callbacks for x86 only is a
> > good option. What do you think?
>
>
> I suggested using the notifier under assumption that if it returns an
> error then that will prevent callbacks to be called because hibernation
> will be effectively disabled.

That's correct.
