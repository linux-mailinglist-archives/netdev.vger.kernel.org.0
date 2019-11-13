Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FB8FB0A0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfKMMlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:41:04 -0500
Received: from mail-ed1-f52.google.com ([209.85.208.52]:34666 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKMMlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 07:41:04 -0500
Received: by mail-ed1-f52.google.com with SMTP id b72so1704453edf.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 04:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3vlDRMktv2tV+fIDmY3q4tVfZiy4d5YkeH8GweL1SOs=;
        b=Ik1sNvOiecEdFnJNUJH8OcbX/e8ilzy5OKtsUGyPXVKcCR76GZJA7pdgcGWDnuoBfE
         iF9U/2kwtBTkpXXr1X2bukpZOYthKjn7vMk2LU6cp6lJ4dFv2/4YY2Mu2YyXglLxR4/q
         6L7OEVLnxZL91f/QWHpqzR/8/yQhzjqM/KsP9NEs3gUNHCCxzLQkPCfXRcqIQkxOC9+8
         PzDu0KSuuK5DKsU6Mf6HNdDtcx+xh3c90ZLNXrEeA1abnej4xA2ym7H+nfuLj4gBmhOj
         IsExqrqDvl1YMXPXwAn6L8eOX9/JqbhbG2BAogKMXI+ga+g0YOeyY72eVb6kFnoOavdf
         mlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3vlDRMktv2tV+fIDmY3q4tVfZiy4d5YkeH8GweL1SOs=;
        b=WlMe6ZdjAC9xUfEv3zq4yZ5QsH0y8ThVGozyMxRg6h8DnvMpDCioXyK+PXGlAq/AWD
         JFpT1Rag8mOzc74oxLWueOLOHdM2lPczruEyBYNWsmYWHGzi02DJv/vUCoMOHE0gqEQ0
         tKay9y3FQvWfs/EbBlg0eL/5ddviQ/65A9kiEx0GUQArbJj7up0EnXCT2sqDVNVgX6c7
         iZZ6DvJK632NUg1ENBihiCt5G4231PlghOUjf9ixdARyjs6c4Mo7XrFisGokfZv514K8
         BWntTn7xuzKXLwsszjxMjazBjLT6r/rpy2VzYb///f3lqmbYzGkvnLCju6Yi0+Le4TqP
         PPFg==
X-Gm-Message-State: APjAAAX10ot2xYilzyFn7g65iOidWKCfAXzgDRz8QfK2GNAQqbJl87Su
        YT2cBaiVjDKOCz+vxYssJrITbsntVJ7/vS+HlMoyR29X
X-Google-Smtp-Source: APXvYqwuhNrDRGOQzxkWDFXY9PRd9D0GNHoLXBHZpUxPiFTYoMDUtE6JJCTLDF6nJog9o2J0XWMaZ86RvQC0mvpM930=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr2482649ejq.133.1573648860673;
 Wed, 13 Nov 2019 04:41:00 -0800 (PST)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 13 Nov 2019 14:40:49 +0200
Message-ID: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
Subject: Offloading DSA taggers to hardware
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA is all about pairing any tagging-capable (or at least VLAN-capable) switch
to any NIC, and the software stack creates N "virtual" net devices, each
representing a switch port, with I/O capabilities based on the metadata present
in the frame. It all looks like an hourglass:

  switch           switch           switch           switch           switch
net_device       net_device       net_device       net_device       net_device
     |                |                |                |                |
     |                |                |                |                |
     |                |                |                |                |
     +----------------+----------------+----------------+----------------+
                                       |
                                       |
                                  DSA master
                                  net_device
                                       |
                                       |
                                  DSA master
                                      NIC
                                       |
                                    switch
                                   CPU port
                                       |
                                       |
     +----------------+----------------+----------------+----------------+
     |                |                |                |                |
     |                |                |                |                |
     |                |                |                |                |
  switch           switch           switch           switch           switch
   port             port             port             port             port


But the process by which the stack:
- Parses the frame on receive, decodes the DSA tag and redirects the frame from
  the DSA master net_device to a switch net_device based on the source port,
  then removes the DSA tag from the frame and recalculates checksums as
  appropriate
- Adds the DSA tag on xmit, then redirects the frame from the "virtual" switch
  net_device to the real DSA master net_device

can be optimized, if the DSA master NIC supports this. Let's say there is a
fictional NIC that has a programmable hardware parser and the ability to
perform frame manipulation (insert, extract a tag). Such a NIC could be
programmed to do a better job adding/removing the DSA tag, as well as
masquerading skb->dev based on the parser meta-data. In addition, there would
be a net benefit for QoS, which as a consequence of the DSA model, cannot be
really end-to-end: a frame classified to a high-priority traffic class by the
switch may be treated as best-effort by the DSA master, due to the fact that it
doesn't really parse the DSA tag (the traffic class, in this case).

I think the DSA hotpath would still need to be involved, but instead of calling
the tagger's xmit/rcv it would need to call a newly introduced ndo that
offloads this operation.

Is there any hardware out there that can do this? Is it desirable to see
something like this in DSA?

Regards,
-Vladimir
