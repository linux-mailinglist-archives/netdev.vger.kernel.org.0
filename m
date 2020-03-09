Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0717DFA7
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCIMRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:17:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36915 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgCIMRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 08:17:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id 6so10803729wre.4
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 05:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hccbbk3rEsStEi8oqAndvplJQwACjWuWTuN0V+AtyJA=;
        b=gHo4aWVw4YonUPb9Jm8nGiECCApB+h3IqncoEGm8rs46YH0TF5I7nINtYhfB0Xrz2G
         8KtBnVhNG7CgM5vGt7vlAtpiwpXawzv09HfpPZqNb243Aa/PZNwsMKs/80BGnhM5WNlW
         EpfikZTtZ2i95cI0mrkw0lez4Rb/yM6SRAGzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hccbbk3rEsStEi8oqAndvplJQwACjWuWTuN0V+AtyJA=;
        b=Nbow8utkhiPZeewhQSl0N6jf45MvHZrC79RAKWymv4FZs/8Y5L5o3zb2SwV/1NZG3o
         PRM65oVWMwNJs1+Xgmq3U6hBfmoOrM+SGNjDaueg0E/GkYEgkSR+QumjTsY5fQdGy77s
         dwVSHkbbs7GLwshQQ/BehlLsxKIJ3aTleRTGdXfLajR8poF8DzsBuXWzJeHJR26T4jT+
         5Sg3L6hEc+Dj7L41S08tc+eU30lkgDopaMc9Ce0cS+C78o6wRIZhYnALJ75BQfjpBpsb
         mTwJ5liaZrNUCKCWsI7bqd0z73/m85V77QVAmXqwXwXsh1AGtsiPTgnwuYlDJ0hXnJb8
         sdpw==
X-Gm-Message-State: ANhLgQ2weFRzog/9lrNw+ljT2ZClbPH56Q49Y09tsfVBDsa4xFpgXYO/
        1k9iiSsK5G/kqV6RYTokp7HnPjzh1bUyBzOEJV+gOg==
X-Google-Smtp-Source: ADFU+vuAXG/aX8jX/kPPz6aoNYGJ1+NJpf+OiCHInlOQPBbJySPzM/DA10DHkzw5AZ2HUaZyj7RqEcatQGjlsHifRiI=
X-Received: by 2002:a5d:6881:: with SMTP id h1mr20181195wru.236.1583756220247;
 Mon, 09 Mar 2020 05:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200307205916.15646-1-sharpd@cumulusnetworks.com> <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
In-Reply-To: <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
From:   Donald Sharp <sharpd@cumulusnetworks.com>
Date:   Mon, 9 Mar 2020 08:16:49 -0400
Message-ID: <CAK989ycxqKU0wYZdfNsMKVOtS_ENg+jhuYu5np7Hd-NdKLo4AQ@mail.gmail.com>
Subject: Re: [PATCH] ip link: Prevent duplication of table id for vrf tables
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Worley <sworley@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David -

I'm more than a bit confused about this stance.  I've been repeatedly
told by the likes of you, Roopa, and Nikolay that we cannot modify the
kernel behavior.  I get that, so that leaves me with user space
responses.  I went this route because not allowing the end user to
make this mistake would have saved us a stupid amount of time from
having to debug/understand/rectify ( rinse repeat for every incident
).  A warning wouldn't have saved us here since this was all automated
and a warning won't generate any actionable return codes from using
`ip link add...`.  If the argument is that other people are doing it
wrong too, point me at them and I'll submit patches there too.  In
other words a user management problem that the kernel/iproute2 hog
ties me from being actually able to stop mistakes when they happen is
an interesting response.

Part of this is that the routing stack considers vrf completely
independent and we don't have duplicate labels to identify the same
table( nor can I think of a good use case where this would be even
advisable and if you can please let me know as that I want to
understand this ).  We have a set of actions we perform when we
receive routing data from the kernel and if we don't act on the right
vrf we've broken routing.  This routing data sent over the netlink bus
is the tableid, if we can't stop users from making mistakes, can we
modify the netlink code actually send us disambiguous data then and
include the label as well as part of the route update?

thanks!

donald


On Sun, Mar 8, 2020 at 10:22 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/7/20 1:59 PM, Donald Sharp wrote:
> > Creation of different vrf's with duplicate table id's creates
> > a situation where two different routing entities believe
> > they have exclusive access to a particular table.  This
> > leads to situations where different routing processes
> > clash for control of a route due to inadvertent table
> > id overlap.  Prevent end user from making this mistake
> > on accident.
>
> I get the pain, but it is a user management problem and ip is but one
> tool. I think at most ip warns the user about the table duplication; it
> can't fail the create.
