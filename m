Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864CEC365F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388764AbfJANxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:53:49 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40640 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfJANxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 09:53:49 -0400
Received: by mail-lf1-f66.google.com with SMTP id d17so9962843lfa.7;
        Tue, 01 Oct 2019 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+a4cT3Bfa3+dG43blKk4kg0OL4X012z5ZuB9Bf9CWc0=;
        b=RU8jaDljAr88uTBeUkx3WshpXPm7h6ZlhbOEJ9gzbk/Klvdv5zEc4cbDZQ0lMiNbEM
         8X6DDLQ7RBuvyVd4hxFNl2eUdyQcTBG3yTCb5+0A+685cbRi64/fc4r0K9WPXL8AeSke
         BKynm0R2B9UZgGHJDahc+WgLtKbqFYjLl5+wfL2am55tNYj1BltT0xEzInKf7OmshrEi
         sjwsg7pjrMGhHZiWW6n2JJv8pNnFsuyUWikfqeYyMS1FtiNtvn1Is8ff34W+C2w0ESMr
         WwSNPzbHyFL11BmPJdg2M49Xe4k/vpdjiTsSrRjO32+XodoIcnAFHLfarf0+RQaNBxNA
         d/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+a4cT3Bfa3+dG43blKk4kg0OL4X012z5ZuB9Bf9CWc0=;
        b=FkyCsi5K9X+3t3isEY9jIaq3mxQHwl/2RtyrAU3ZPIGoYazihb2j3fyf+5jF60HQTr
         luuFpP60898KwLCPzKi1MonPcjNQaQmw4gqYxCcn0pjdZZaMEvNlqdI/DkYpGGfoOIMn
         rhQ3iFJx5saTq5JYB2TC9QEqduiE3/5eEFcffEjcHBolz1TNR4+cZTNw45eThzad7sMd
         MuEqGaRhB8qfcjslI0p9VdckQbZE4YakPOTtWwm2oHarLchjKRa6Az6W+34GOMRoD802
         pelxfLrIu8tozSFK4C2WYprWlyT9ZomRawud1UZe8WKVS4XUpKhvf8ofGjuKYgw4clpB
         IHjg==
X-Gm-Message-State: APjAAAV6dbmgMD2eJC6Mh14isXutfAzWybdv+Q7KFG1ZnBA7SGWrylWF
        sPYxQ0ygQFfJoFGRo0BtOFXfmKAw6k+/894Y3Fk=
X-Google-Smtp-Source: APXvYqyi+t6tHONzzKcqA/Yb1SDfW/0FFkqIW3tzycIYNxkPQwvxKLon2OT/OVKWbT16aqnO1nqp2k9FP95D9UzVaEQ=
X-Received: by 2002:a19:c191:: with SMTP id r139mr8350753lff.23.1569938026190;
 Tue, 01 Oct 2019 06:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-2-ap420073@gmail.com>
 <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
 <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com> <39e879f59ad3b219901839d1511fc96886bf94fb.camel@sipsolutions.net>
In-Reply-To: <39e879f59ad3b219901839d1511fc96886bf94fb.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 1 Oct 2019 22:53:34 +0900
Message-ID: <CAMArcTW6q=ga1juv_Qp-dKwRwxneAEsX4xQxN-n19oWM-VUQ+w@mail.gmail.com>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 at 16:11, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>

Hi!

> Sorry for the delay.
>
> > These functions are used as a callback function of
> > netdev_walk_all_{upper/lower}_dev(). So these return types are needed.
>
> Ah yes, I missed that, sorry.
>
> > Without storing level storing, a walking graph routine is needed only
> > once. The routine would work as a nesting depth validator.
> > So that the detach routine doesn't need to walk the graph.
> > Whereas, in this patch, both attach and detach routine need to
> > walk graph. So, storing nesting variable way is slower than without
> > storing nesting variable way because of the detach routine's updating
> > upper and lower level routine.
>
> Right, that's what I thought.
>
> > But I'm sure that storing nesting variables is useful because other
> > modules already using nesting level values.
> > Please look at vlan_get_encap_level() and usecases.
>
> Indeed, I noticed that later.
>
> > If we don't provide nesting level variables, they should calculate
> > every time when they need it and this way is easier way to get a
> > nesting level. There are use-cases of lower_level variable
> > in the 11th patch.
>
> Yes, makes sense, agree. One could argue that you only ever need the
> "lower_level" stored, not the "upper_level", but I guess that doesn't
> really make a difference.
>
> Placing these in a better position in the struct might make sense - a
> cursory look suggested that they weren't filling any of the many holes
> there, did you pay attention to that or was the placement more or less
> random?
>

If I understand correctly, you said about the alignment of
"lower_level" and "upper_level".
I thought this place is a fine position for variables as regards the
alignment and I didn't try to put each variable in different places.

If I misunderstood your mention, please let me know.

Thank you

> johannes
>
