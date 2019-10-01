Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD2DC2CB3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 06:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfJAEor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 00:44:47 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32853 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJAEor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 00:44:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id c4so10654198edl.0
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 21:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nYHrc/En4nXXJUQZBsIs5NaWoR+ss41GDSBl7Yv+ZRM=;
        b=eHRqFfhK7KXLaXzp1i6Lx2SYWBtfFgIDWQncmSJQFF2Boq2GJIsK+pX7P2Ss+uagWW
         3K9uQZZUmSVhVTByXgz2KKtFsPyju7gvY2foRY8NuJTvhzumaf/d9sqLZ47sWTVGAmVt
         IkonP8JeuAAKUdWOMuYZjXLFCLEZDx9PWSfY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nYHrc/En4nXXJUQZBsIs5NaWoR+ss41GDSBl7Yv+ZRM=;
        b=GiaE7cLQlehzggk0DwDy/ZJ5CDD5iLrIk5WKuvoichAfoPhOPsIKtrpJeiOX6xKj7W
         pNhgpydOOgxGViqKXP3KcISPJgzDvnFw7IFM/qZLrw+4GZFJB6yH7hu6eCF0QIgtOuXf
         ctg3lufkfI9BD3DEWEXFWWqK+IS2HK1jrlGEBrN5fag4YnVfUwvvKPNnKhg0FtanT925
         STqRQJJSjEHPh9g/nERzVpUALKyPqI8KQh7MZ6ZB4fNAOdOGx9cJ/zY3CVf7Ew2WSCzS
         k288Ez8PfZ+9nXjJP+8Hrc1YWDqt4+9oOj+qZO6k8sW/vOsScw+2l7Pkrc1Gv5tEwEbT
         5uug==
X-Gm-Message-State: APjAAAV+E+Kvj40G54Cs0lR/loCIUx7MDawrbLij3W5J9hpKxIV9k14e
        hFk0nMHne9+effEQ7dfsr1YnhtGBBAAWkiAlvIDgzQ==
X-Google-Smtp-Source: APXvYqzcBc3o2uG9OTe9HDmgTqfOkQAoTUdhqD8Xj/paf6LuDZtayeZM7wCq9TEm+RyNbGaMCbLnfV4mEEfcTk51hiQ=
X-Received: by 2002:a17:906:6848:: with SMTP id a8mr22855647ejs.104.1569905084260;
 Mon, 30 Sep 2019 21:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
 <1569702130-46433-3-git-send-email-roopa@cumulusnetworks.com> <d256f178-ec5a-abaa-1528-0690d059b243@gmail.com>
In-Reply-To: <d256f178-ec5a-abaa-1528-0690d059b243@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 30 Sep 2019 21:44:32 -0700
Message-ID: <CAJieiUgziCGhqe8-tXh1hkD_fzjXVS4HfsedT20tDwrXMm3SRA@mail.gmail.com>
Subject: Re: [PATCH iproute2 net-next v2 2/2] ipneigh: neigh get support
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 9:42 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/28/19 2:22 PM, Roopa Prabhu wrote:
> > +
> > +     req.ndm.ndm_family = dst.family;
> > +     if (addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen) < 0)
> > +             return -1;
> > +
> > +     if (d) {
> > +             ll_init_map(&rth);
>
> ll_init_map is not needed and really not something you want to do (it
> does a full link dump)
>

ok got it, the get index macro does a getlink if map is not initialized.
(there are still many calls to init_map... possibly for cases that
require querying of multiple links)
