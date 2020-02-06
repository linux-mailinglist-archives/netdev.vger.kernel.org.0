Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FC9154133
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 10:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgBFJdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 04:33:05 -0500
Received: from mail-ed1-f44.google.com ([209.85.208.44]:43666 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBFJdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 04:33:05 -0500
Received: by mail-ed1-f44.google.com with SMTP id dc19so5163392edb.10
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 01:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=2WZerayGOcRnkUdi9noyopTRscTc2K6TmvtDVKjL6iw=;
        b=u9F/Z0hnK3qJO4g9AoION3U0NDpRo/l4gPIGmkf1ZXxe+5lEbdH9P2/gwcaX8IE4uu
         CtH8uYfBRYgwkdmIiO7v78yrauEgPZ9+nzVxK91LeQAoCFs5W4BAMh7wCbdcSewrKrHO
         WNXhn/1ZHlh5FDSWywWl52DfFUB7UFRYnv4QdgB7rzCRBsiOSNCjHEWk3LLGFMNxHiSW
         tGMjekgOhtKRg3iMhBo+SLMhmONxM29YLrCw1Q7QaxJNo6n1+JwxmIMPzRUrVw+9F9UJ
         2KCYurA1RDVpUnJU7S2a4KBiqLTARBigMDn3wNh871ePYwIKi29kZhQmZRu5nmSn+1jS
         sQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=2WZerayGOcRnkUdi9noyopTRscTc2K6TmvtDVKjL6iw=;
        b=hh9cxwnolvU29p2c2ouX5NSA1XOA0PA8mKgcTIyOaci7BqjNPbe3eRJqSAXjZkq2P5
         OHomQPcpGftuS5WIv1AOqg6xh/GiNF2aJuffvLZCTHUBFvsqRNIwbT+4yjhr19ogUWUm
         VJgLnKRokD552FZ22a6nXnA63FYF23sD5djvcXdJzBCm5s+FVamt4gVlwxqU5jqKQSFB
         roCpPs5OykHQkfptOk/qauaKGUSD0wKyT+uCdBjzj/s+KRJ5/iwHojJc5mMjWcJBmWEi
         La0e8XRRniFYAdEVGzAiHY/ff7DtBCHmRED/jtOqDynj90XA7EC+cjvZJflCNku0M1ma
         SQ+Q==
X-Gm-Message-State: APjAAAXN1jnN6NB04UMVLrpWIPrxXyeGq9R1LFIqZHUBf2gsefyIagnf
        yXJN+UsW1k/ilblXEsh2dbgRkkIA1JwA+MYsKwCNlA==
X-Google-Smtp-Source: APXvYqwT99FzoDlT5pxYKxE6sR0KyVA0YEZGO71HMJoQsPAWnS+PvHfIShmCkJoGXDwnuMV7M3PVNltruomOg8NlZNs=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr2536039ejj.6.1580981583372;
 Thu, 06 Feb 2020 01:33:03 -0800 (PST)
MIME-Version: 1.0
References: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
In-Reply-To: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 6 Feb 2020 11:32:52 +0200
Message-ID: <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com>
Subject: Re: VLAN retagging for packets switched between 2 certain ports
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Feb 2020 at 11:02, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi netdev,
>
> I am interested in modeling the following classifier/action with tc filters:
> - Match packets with VID N received on port A and going towards port B
> - Replace VID with M
>
> Some hardware (DSA switch) I am working on supports this, so it would
> be good if I could model this with tc in a way that can be offloaded.
> In man tc-flower I found the following matches:
>        indev ifname
>               Match on incoming interface name. Obviously this makes
> sense only for forwarded flows.  ifname is the name of an interface
> which must exist at the time of tc invocation.
>        vlan_id VID
>               Match on vlan tag id.  VID is an unsigned 12bit value in
> decimal format.
>
> And there is a generic "vlan" action (man tc-vlan) that supports the
> "modify" command.
>
> Judging from this syntax, I would need to add a tc-flower rule on the
> egress qdisc of swpB, with indev swpA and vlan_id N.
> But what should I do if I need to do VLAN retagging towards the CPU
> (where DSA does not give me a hook for attaching tc filters)?
>
> Thanks,
> -Vladimir

While I don't want to influence the advice that I get, I tried to see
this from the perspective of "what would a non-DSA device do?".
So what I think would work for me is:
- For VLAN retagging of autonomously forwarded flows (between 2
front-panel ports) I can do the egress filter with indev that I
mentioned above.
- For VLAN retagging towards the CPU, I can just attach the filter to
the ingress qdisc and not specify an indev at all. The idea being that
this filter will match on locally terminated packets and not on all
packets received on this port.
Would this be confusing?

-Vladimir
