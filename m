Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB3102ED8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfKSWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:07:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37071 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKSWHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:07:44 -0500
Received: by mail-lj1-f193.google.com with SMTP id d5so25150505ljl.4;
        Tue, 19 Nov 2019 14:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/NIY0wwmd8kAAZ+E6bHh2DYRDKjCV9YXkhsBIS0hJcs=;
        b=TmoEW5GcPBJMZqxK1rUqJR+pE+JkTQcZyhd9lOiEtnWQEuFPNrgX5RYkHLUP9k2dzB
         F4v4WkOhxv2utmOmoTqSNP5+evY5Tmy6uMdT9Q34YFY0Cx6LLn9ru8FaoWrd0IJm7HNi
         IwWzM59zcT00oGu7h+67Osw+f47swWpY3WSsj5LoLK0A36rTSGInVPFWkWvMOc7TduUe
         Rkw/epEcJCLQd8Ry59u/bRUDt6kN+1ycbwiMu8u+/wZTn+ISKto9UYEniYR8N7r9I3fr
         iW3sKN+rAi2seboekh8qieg6ZU+am7W8u4iHTQMH85GfLVc0xFKEZ3ZPj19FwgK+9PPQ
         Hi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NIY0wwmd8kAAZ+E6bHh2DYRDKjCV9YXkhsBIS0hJcs=;
        b=V3zfMBzN6JQTjeHDh/YwbkerSHx2rGL1Gsb0TN9dlaUHYURifgNfNxcbM1X7Q53V5s
         sfh4/8ee7bcRuuwXqVgoXVUY/yFrfsrgzglA+xOl+77LpDqq9NoWgYJi8ODMA+IZZUIt
         X+Ywe01LMEL7cd5WCyOp4w9dMczlcbdy8pRYA8KLg6WCq2DBGh5+dt62aIn43EZiFDaN
         vJENq9K+1uo8OzYw6aPVW77IG9TR+3ECGUplLviidWGOV8U8ZMP1xwAD0p0MY//l1iyL
         Nd2tVZE0appwjMR6Vc+WgXshof2VI2e2HCt9bcKRx+ZH0ROgs0zUhbh6HxZ3MPH3lkYC
         9kZw==
X-Gm-Message-State: APjAAAUWCAZak4yDXvR2KRzwus74fZYgvJAlj2h2wOozS2qL2quqHLDg
        3oPp/gm3jdBmiui0nirZ7pCF0IlyUXOFO+1/wWM=
X-Google-Smtp-Source: APXvYqyoQLekI+Vh3I0S26z+Ix5Ed7Z6kLQCJi/wzt6okOYA5unIq30BI/YrCgYtnyaqmaVRPh68qgdfUOqklLCj8As=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr5665605ljn.188.1574201260547;
 Tue, 19 Nov 2019 14:07:40 -0800 (PST)
MIME-Version: 1.0
References: <20191119001951.92930-1-lrizzo@google.com> <20191119140301.6ff669e1@cakuba.netronome.com>
In-Reply-To: <20191119140301.6ff669e1@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Nov 2019 14:07:28 -0800
Message-ID: <CAADnVQJADNUsJEGvstJco3cQ9YVyU9To5vVLH+SyXZ7zgi4pYw@mail.gmail.com>
Subject: Re: [PATCH v2] net-af_xdp: use correct number of channels from ethtool
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Luigi Rizzo <lrizzo@google.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, rizzo@iet.unipi.it
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:04 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 18 Nov 2019 16:19:51 -0800, Luigi Rizzo wrote:
> > Drivers use different fields to report the number of channels, so take
> > the maximum of all data channels (rx, tx, combined) when determining the
> > size of the xsk map. The current code used only 'combined' which was set
> > to 0 in some drivers e.g. mlx4.
> >
> > Tested: compiled and run xdpsock -q 3 -r -S on mlx4
> > Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied. Thanks
