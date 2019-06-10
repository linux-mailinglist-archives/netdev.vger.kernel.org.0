Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DF13BD97
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbfFJUhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:37:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38840 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389429AbfFJUhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 16:37:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id b11so7603899lfa.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 13:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C03A8Nqv4Z/uQHXvJmwhd/yxTlVNQOPTQVSatHKaE7Y=;
        b=IokEPEf5TOCfPwjQskU/jiFomSVaZYrhk+f3PJEYSCrv4paE9Ndpn/bjiCV1oEfbs7
         9/7Pz7Exf+2WKO2XH8A8YE9woIhEtI7/Ys7/VMt9x5H5cvQ11vrHjnVeWzSBQhyw7HBL
         bJ+xmFl8y02EogC+9ttboIX/BP4psyLXn07nMX+4oq1LGcnRXO6ZUudL7+JxUxXTnnnL
         /QiUWyTBe2zKtdC5MNH3W3L6x062C9cwq7+FpISUC/UcRebk7mUmJlkUWUvb2fAW0v8S
         7I5dViVwz/PlgAJLnwqUWXFIjChvyLw+dQ9B/5mukFUXUjtm4clSKIJrHKGVyWR/VRC1
         7LBA==
X-Gm-Message-State: APjAAAWukQU9ACRWYUF49FGkz+f4TJBKITObfFh18MFGUuE9dVBnHb6I
        LjubyqJsaBEEpH0EdmSdpMfP51t1x7JoEAqVUuAGpjJB
X-Google-Smtp-Source: APXvYqxioeJciGpE2cp8VnWkuWFhrdanh8HRfLm5gZMaQ6fX67ZeWL06fGH/SHTPDqs4vBJSiE5otlkwtGY0C+dU/bc=
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr21431859lfn.46.1560199054359;
 Mon, 10 Jun 2019 13:37:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190607204122.2985-1-mcroce@redhat.com> <20190610104737.3bcd1e7d@hermes.lan>
In-Reply-To: <20190610104737.3bcd1e7d@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 10 Jun 2019 22:36:58 +0200
Message-ID: <CAGnkfhyOAkRqQEMRwq7+otraCg8kMCkJxkUiNYE3mJWNrPxJEw@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2] ip: reset netns after each command in batch mode
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 7:48 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  7 Jun 2019 22:41:22 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > When creating a new netns or executing a program into an existing one,
> > the unshare() or setns() calls will change the current netns.
> > In batch mode, this can run commands on the wrong interfaces, as the
> > ifindex value is meaningful only in the current netns. For example, this
> > command fails because veth-c doesn't exists in the init netns:
>
> Applied, thanks.

Great!

I was thinking about the code flow when running ip netns exec in batch
or doall mode:

1) save the current netns()
2) change netns with setns()
3) clear the clear vrf associations with vrf_reset()
4) fork(), exec in the child
5) restore the previous netns in the parent

With a little rework (adding a parameter to cmd_exec), we could change
the netns directly in the child, so the parent doesn't need steps
1,2,3,5
This could save some errors where the previous state can't be
restored, eg. netns, vrp or the like.

I have a draft patch for this which, by the way, eliminates some dead
code, I will send to the ML soon.

Regards,
-- 
Matteo Croce
per aspera ad upstream
