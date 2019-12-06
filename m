Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6CC115627
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 18:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfLFRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 12:09:22 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]:36471 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFRJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 12:09:22 -0500
Received: by mail-qk1-f169.google.com with SMTP id s25so2126372qks.3
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 09:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LJVr1VmjslLqmOTXhGTSstIvwi0XtIfpztOHpjoQcI=;
        b=ifiACubAK5p+PPSoIWaSFNdGYssBpL11sQGqGwJbSRKvK8oAUTloevwxoB2G6XR2le
         nBtKbjvj8aFM8djt09jvJqvmU+R8pC3OL1hYiaugCWjp4hFAOwU0sl3oXmQCuD63UO7X
         OYUoOXGIT9x8Vut1n14B8/cxbZoQe3Oe0Q/ZwZWbZ46VZupMwxiYms3/VA0MjcEnSN4y
         9Bp58qtzhzx6hXA8MDUz2lTiHuXSOIwBq90FKsL+If/cazv9z4mB9VDdp0RqBHAXV2rY
         eXMFV8OlC3Wjam+FqgweO9FMS0v8R++sLa7QS285egLNvnZbAwETL9iLL470H0ZYYJW9
         5UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LJVr1VmjslLqmOTXhGTSstIvwi0XtIfpztOHpjoQcI=;
        b=i6Vp88xCR13NNnfa9HgCc+fqwhZi9KvLZvi+ThyiqYgBr9Kv0Zi+5r7wYn1z2fPA8l
         Uzof0/si9BtQDTOqKFhp/5nTRE6OXTknKZS6MiAqobBCbZjwBB0eSadojz6WzrhfD+A8
         vP/Aj9UQ9hJW1bmGGkhCZJU/XJlSezAIReBn2V4oS6UQE+tguqV3fnwNyngCKutNQ2ta
         6FaMbjziIkVeEsyuV0bI4TfuYjgqrgqVd4Xe2V8fzMpzkKSgpjU62YMt5/CzFhXYSTZ9
         E0qU5ANf4DmcP6IMCT+1heX/B4l8B7qVQbKrFTVRLv7y8+CWSVZ/gxTB+wgoD20trtdR
         qvtA==
X-Gm-Message-State: APjAAAUAAApPRIhB25/uE3lTNz7ZJpWwtAr+C1jDiUpyqgA6UxZEhG4S
        0CDwwR2PM4WBXjbBdFuzXEYOMG56B9QkS7Ui0Wo=
X-Google-Smtp-Source: APXvYqycFax2ilw4kyuNCH6HbO9tO+UxIaDuuDqsL2LeB4P6KP0Hji2K0m7rfe31sG2da9qqDrE3Yf4su7o7r9EmBYw=
X-Received: by 2002:a37:9acb:: with SMTP id c194mr14430807qke.291.1575652161080;
 Fri, 06 Dec 2019 09:09:21 -0800 (PST)
MIME-Version: 1.0
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com> <CAJ0CqmW8TYO4jasC4UVXALWHkvaU+S7Uu0V=TDojwZwiJV2TxA@mail.gmail.com>
In-Reply-To: <CAJ0CqmW8TYO4jasC4UVXALWHkvaU+S7Uu0V=TDojwZwiJV2TxA@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 6 Dec 2019 09:08:44 -0800
Message-ID: <CALDO+SbGB2DmSQ-FzLCvNvU+nvHmbxpoNeyZHOwJbgbha6EZwg@mail.gmail.com>
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after pskb_may_pull()
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 3:50 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> >
> > After pskb_may_pull() we should always refetch the header
> > pointers from the skb->data in case it got reallocated.
> >
> > In gre_parse_header(), the erspan header is still fetched
> > from the 'options' pointer which is fetched before
> > pskb_may_pull().
> >
> > Found this during code review of a KMSAN bug report.
> >
> > Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
> > Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>
> Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>

LGTM.
Acked-by: William Tu <u9012063@gmail.com>

From the  spec, ERSPAN has fixed size GRE header, so  I think
WCCPv2 should not exist in ERSPAN.
