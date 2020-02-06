Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580A01540D1
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgBFJDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 04:03:10 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:42129 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBFJDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 04:03:10 -0500
Received: by mail-ed1-f48.google.com with SMTP id e10so5081966edv.9
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 01:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IXvMOQDlXmn4zH5JtxKFz1LCT4l0Wa8kDJCsvIosdkA=;
        b=aexYpC5SegjeDJ2g7wxtIxNb57GQw/MksC4r4WmYa8skfsIHOmcLQ6NWUijfIw7Vdx
         LKuaBgrZshanG/Vk0o/47gDR0IQ1lUZIveb8170nLOGGguzoGVsSiO/njFEM63prTahZ
         QLoVF515qIfUGQd/fYgE3dkSUkzIKeBGqMTWGZW4j4obbyU/OFruUF2nNgVM05BWsmBK
         V3xUlS6josgp+W9LiZHHDoTsJT5hvzDWNSg/WUSLe94C+3aeo3HePrzcWcZlQVn9l54j
         HUsCLe3Z6PI7Gt41ahLCfLz4GrexkSqRPZr8mYmggz+vhIBDsVzqxirsmVTS6eCU/7Jy
         nxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IXvMOQDlXmn4zH5JtxKFz1LCT4l0Wa8kDJCsvIosdkA=;
        b=UyaKmdZe/03qApLTkuVvgeHooVMnLhtZBdg/Al2n8naKoZM+wksFLebskHJIO0HfIS
         Sboyc617+ssfRZDurLFQ942/6IqxtwvqbOzgsnPgk0IgdvaxM4knZ8ezjv29+qEJlrHo
         W5D07MRYLIGQW8w8HW5Y3Oxfrp10+28wOHCnrv/YY9sDluL+sXv0RTDEpNYsm4R2xTlh
         cRu12ez/qvVE8tZRWXbnE3ZbMxk2Myhk7RJw9Jr5RoJDD+4iG5F0EFDv01akuElQ3z4s
         JAqtcWVvPXUP6te+/PlIA8s06ubOduqEwEhi9r9Q+emzH1GWpvwMAdMOMm1fBcEu4018
         zrDg==
X-Gm-Message-State: APjAAAU6Bagq1rDW0Gh/HhGKgCcQtt2jyqIXqG7IQzQiRuY1GOwgwZ3Q
        CEwTkxFyyBRVJyq4b03zc+B4pm0vVFUUxG4rRnqfI7g5
X-Google-Smtp-Source: APXvYqy9f9HodWFNyLmDW6oQvIaYs25qoo9xBaOtevGk9NJipmpsoJUKaHe9r81tRMwLj+KQsKa6se8YdLlrFOVlke4=
X-Received: by 2002:a17:906:af99:: with SMTP id mj25mr2214953ejb.293.1580979788369;
 Thu, 06 Feb 2020 01:03:08 -0800 (PST)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 6 Feb 2020 11:02:57 +0200
Message-ID: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
Subject: VLAN retagging for packets switched between 2 certain ports
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

I am interested in modeling the following classifier/action with tc filters:
- Match packets with VID N received on port A and going towards port B
- Replace VID with M

Some hardware (DSA switch) I am working on supports this, so it would
be good if I could model this with tc in a way that can be offloaded.
In man tc-flower I found the following matches:
       indev ifname
              Match on incoming interface name. Obviously this makes
sense only for forwarded flows.  ifname is the name of an interface
which must exist at the time of tc invocation.
       vlan_id VID
              Match on vlan tag id.  VID is an unsigned 12bit value in
decimal format.

And there is a generic "vlan" action (man tc-vlan) that supports the
"modify" command.

Judging from this syntax, I would need to add a tc-flower rule on the
egress qdisc of swpB, with indev swpA and vlan_id N.
But what should I do if I need to do VLAN retagging towards the CPU
(where DSA does not give me a hook for attaching tc filters)?

Thanks,
-Vladimir
