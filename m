Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C893B5400
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbfIQRWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:22:01 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39874 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfIQRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:22:01 -0400
Received: by mail-yb1-f196.google.com with SMTP id o80so1692069ybc.6
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 10:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C45O6wNgjT/lAKouN4O9SoXKTjXG5cFFmbX13MYKZvs=;
        b=dwaGTUfAfqbYnNeBZ6MuyBDgzYgaLOlp97w6vf/eYfHh5zK09XCtPTq+l8fW2k4YJ0
         ZWttaKlu1E0ujdyPQdUQ1GL2RgnzDJSlpO1PBKAGun7deBiGJdEn/WtcP5algDu2uHOl
         E41lQ32pa8YGUQpgKUvU0UWEse6gbE1amblYHhTiBJE+Q+xxL8tyyAdpiS+LqK4KKBdF
         SLhNWJmEu7kwez2UhDmjgohhAdg+P3vPwpvWY9zZBphGahWC6Fb/A7VZoFZj1TWoYkM4
         4l89XkClbr1KVvNPu1nHJBfTjlEufbPH7mLmLTvxEdgk/nc8hi+1SmPPQC8t/umEGhxu
         LW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C45O6wNgjT/lAKouN4O9SoXKTjXG5cFFmbX13MYKZvs=;
        b=SsvxKkaTkvqC8cYRIUvfW8+F2NcsjLxzFjum5X9jSkLXWj+opj05Z9uGBYKQ9SpAvJ
         dJK0wJpr2Ztfb1A7paAgjEuuky2/BW0rHV+iBisO504aXmgZSZZN2f2cZ0x9jPxO8lnw
         NiWevz64dCuF2T2cfnmEeHcou9lmndyas2X1d17WZQQubCDBxfyiXFBqzx65PycxjfyH
         SKCHXxL6nSh+6srjPTR935PLY87hh6nlPkcpPP0HZYb08hJZOCW5J3RW8raU2J0q8BE8
         qhCQKXIJym9lfU6wcsQ4GBlbZsyo6dJyrXYAVpIlvT/2V5hBvoi08C/vuCVui8JoiD8M
         wbRA==
X-Gm-Message-State: APjAAAWlbVj1N/4NuGdCEMfROa11H5r5+dbKK34ki3WRVhp0V4qJCG6D
        WWW7PKap+0CZ65jP+LQ81aqo+HdpeQGDHYZWADEycQ==
X-Google-Smtp-Source: APXvYqzqjJ32l+tAOrPRE1pgr27hv4gAkgPYmptvK8vkQCGo8NYjeE1rhiTP8De0DM7In0G8mWpWnTyFMP2/sczgJpY=
X-Received: by 2002:a25:1f41:: with SMTP id f62mr3054118ybf.518.1568740919666;
 Tue, 17 Sep 2019 10:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190910201128.3967163-1-tph@fb.com> <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
 <2c6a44fd-3b7e-9fd9-4773-34796b64928f@akamai.com>
In-Reply-To: <2c6a44fd-3b7e-9fd9-4773-34796b64928f@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 Sep 2019 10:21:48 -0700
Message-ID: <CANn89iKJdMGD6kdKrQJk_sHO4ec=Ko3iAiBy_oDzU2UPGtvJNg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Jason Baron <jbaron@akamai.com>
Cc:     Thomas Higdon <tph@fb.com>, netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Tue, Sep 17, 2019 at 10:13 AM Jason Baron <jbaron@akamai.com> wrote:
>
>
> Hi,
>
> I was interested in adding a field to tcp_info around the TFO state of a
> socket. So for the server side it would indicate if TFO was used to
> create the socket and on the client side it would report whether TFO
> worked and if not that it failed with maybe some additional states
> around why it failed. I'm thinking it would be maybe 3 bits.
>
> My question is whether its reasonable to use the unused bits of
> __u8    tcpi_delivery_rate_app_limited:1;. Or is this not good because
> the size hasn't changed? What if I avoided using 0 for the new field to
> avoid the possibility of not knowing if 0 because its the old kernel or
> 0 because that's now its a TFO state? IE the new field could always be >
> 0 for the new kernel.
>

I guess that storing the 'why it has failed' would need more bits.

I suggest maybe using an event for this, instead of TCP_INFO ?

As of using the bits, maybe the monitoring application does not really care
if running on an old kernel where the bits would be zero.

Commit eb8329e0a04db0061f714f033b4454326ba147f4 reserved a single
bit and did not bother about making sure the monitoring would detect if this
runs on an old kernel.
