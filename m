Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B219139FDEB
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhFHRnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:43:02 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:42817 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhFHRnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:43:01 -0400
Received: by mail-oi1-f175.google.com with SMTP id v142so21897731oie.9
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ifWNI0Y06EMrvpmxrX3HdEcHCzhlFx5Cd+IHeVFjUo8=;
        b=do5luAmwhzalCWPKncpBgjFX6cFnDKYcQizEem9mzCXtIdBT5DXCax/zJCj8MiN7mv
         j9AlquROWlr1RCVpz6STXtEpp9nUNWDK6UoLGQx/QI71qlDnFyXaadkfYke2etgojzM3
         y5FWf280RKNeteoS0c1GLLv4cJ+kKWQ4lLaVitS9jhIzsipSlNw6ObiwVYNKuHxki/T7
         Wl9GHEOl6z6ODUd6Z9sG7UrCzA2DGVrDA/aC0iYU/VvL8/h7CW4zN+MMnq/lK7pQUlZC
         a3iqwvOA24xOa8Ur5aiKI1hDp0D71eIIAEYXmD1Fi8D9laAqz58ZZTNiVudiN19RvP0P
         tobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ifWNI0Y06EMrvpmxrX3HdEcHCzhlFx5Cd+IHeVFjUo8=;
        b=KvjbK0NwJ9V2D/pBG3ufA3RCk2+FAdPliUHzjNbcNVpWAkKrMUV7Q3eIoDj9Ocnnb7
         Lkts9zX8lEakEck0IxwWpMROKym9GkJblbA/8j+UcJduxVbTSfH2/kfUOmaOeVPQqWZM
         XBns8WuIRfwpQiVfGgWqSJzP6lEIBqfcORXrJwZwGmtZJ4Ew+/9h7mMlqZigoip481gt
         gLCgUU08vSkp3HEq3KAsTTbRJYKpXLVd142/GsLH5ikluVG29I1bN3GoQW9XCIT4YycP
         e1scqh2uH0P0teNtGjfnCMAZhfTrvPc1eahLBrHZsQpqQe/YjOe+mMfpS90SUBWQ1dff
         AggA==
X-Gm-Message-State: AOAM5337Xa4m1zy0YwQ+ecyzP+YkiPjkye7+hkJZzvljuwaoL1Bf5q9a
        CenWZW1ior91THYfDGz+uAJKYhBFHHY2JxMGIb8L2Krn18/+vw==
X-Google-Smtp-Source: ABdhPJyKojGzKhZ3YmMSALX8YRleMMWvB9X2xu0BO1+EdnKOPxMDNmjn79/Q2NXTMA9i/+KggzJ+mFhXwvYxTbpF7Ok=
X-Received: by 2002:aca:f5d6:: with SMTP id t205mr3651883oih.58.1623173992683;
 Tue, 08 Jun 2021 10:39:52 -0700 (PDT)
MIME-Version: 1.0
From:   Lalitha Sahitya Maruvada <sahitya.lalitha@gmail.com>
Date:   Tue, 8 Jun 2021 10:39:41 -0700
Message-ID: <CAFxY_EsE6t_ezpQ5HyiTc_PhLAkX=hbEO1b77JLKihuEOm7VZA@mail.gmail.com>
Subject: TC filter rule not doing an atomic replace for tc-matchall filter type
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a tc-matchall filter rule attached to a qdisc associated with a
wireguard device. When no tc filter rules are present, executing a tc
replace command, creates a new rule as expected. But if I try to
re-run the replace command without any changes (or with any changes),
it errors out with EEXIST. Ideally it should perform a nearly atomic
remove/add on an existing node id, or add it if it doesn't already
exist.

I also have a tc-u32 rule associated with the same qdisc, this rule
does atomic replace, as expected, without any errors.

I am suspecting it is specific to the matchall filter, There is a bug
reported with the u32 filter that is close to this, but not quite the
same.

 I have tried the matchall rule below on tc versions 5.4 and the
latest TC version 5.10 as well, but it errors out with File exists, we
have an error talking to the kernel.

Here is the set of commands used for replicating the scenario.

$ ip link add dev wg1 type wireguard
$ tc qdisc add dev wg1 root handle ffff: prio bands 2 priomap  0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0
$ tc filter replace dev wg1 parent ffff: prio 99 handle 800::800
protocol ip u32 match ip src 192.168.8.0/16 classid 1:1
$ tc filter replace dev wg1 parent ffff: prio 300  matchall action
sample rate 100 group 12 action mirred egress redirect dev ifb0

Output of tc filter show command after executing the above commands
looks like this

$ tc filter show dev wg1
filter parent ffff: protocol ip pref 99 u32 chain 0
filter parent ffff: protocol ip pref 99 u32 chain 0 fh 800: ht divisor 1
filter parent ffff: protocol ip pref 99 u32 chain 0 fh 800::800 order
2048 key ht 800 bkt 0 flowid 1:1 not_in_hw
  match c0a80000/ffff0000 at 12
filter parent ffff: protocol all pref 300 matchall chain 0
filter parent ffff: protocol all pref 300 matchall chain 0 handle 0x1
  not_in_hw
    action order 1: sample rate 1/100 group 12 pipe
     index 1 ref 1 bind 1

    action order 2: mirred (Egress Redirect to device ifb0) stolen
    index 6 ref 1 bind 1

Re-running the filter replace commands should ideally do an atomic
replace without any errors. The u32 filter behaves as expected, but
not the matchall filter. Here is the output when I re-run the
commands. I have a service that re-runs these commands when a few
conditions are met and it is essential that these commands shouldn't
error out for the successful functioning of the service.

$ tc filter replace dev wg1 parent ffff: prio 99 handle 800::800
protocol ip u32 match ip src 192.168.8.0/24 classid 1:1

# running this command again fails with the error below.
$ tc filter replace dev wg1 parent ffff: prio 300  matchall action
sample rate 100 group 12 action mirred egress redirect dev ifb0
RTNETLINK answers: File exists
We have an error talking to the kernel

On a side note, one other thing that is observed is, if I run a
replace without specifying the prio, it ends up creating a new rule
with a different prio

$ tc filter replace dev wg1 parent ffff: matchall action sample rate
100 group 12 action mirred egress redirect dev ifb0

$ tc filter replace dev wg1 parent ffff: matchall action sample rate
100 group 12 action mirred egress redirect dev ifb0

Output of tc filter show dev wg1 command, after running replace
without specifying a prio. This really isn't my concern right now, my
problem is replace erroring out with EEXIST when prio is specified.

$tc filter show dev wg1

filter parent ffff: protocol ip pref 99 u32 chain 0
filter parent ffff: protocol ip pref 99 u32 chain 0 fh 800: ht divisor 1
filter parent ffff: protocol ip pref 99 u32 chain 0 fh 800::800 order
2048 key ht 800 bkt 0 flowid 1:1 not_in_hw
  match c0a80000/ffff0000 at 12
filter parent ffff: protocol all pref 300 matchall chain 0
filter parent ffff: protocol all pref 300 matchall chain 0 handle 0x1
  not_in_hw
action order 1: sample rate 1/100 group 12 pipe
index 1 ref 1 bind 1

action order 2: mirred (Egress Redirect to device ifb0) stolen
index 6 ref 1 bind 1

filter parent ffff: protocol all pref 49151 matchall chain 0
filter parent ffff: protocol all pref 49151 matchall chain 0 handle 0x1
  not_in_hw
action order 1: sample rate 1/100 group 12 pipe
index 4 ref 1 bind 1

action order 2: mirred (Egress Redirect to device ifb0) stolen
index 10 ref 1 bind 1

filter parent ffff: protocol all pref 49152 matchall chain 0
filter parent ffff: protocol all pref 49152 matchall chain 0 handle 0x1
  not_in_hw
action order 1: sample rate 1/100 group 12 pipe
index 3 ref 1 bind 1

action order 2: mirred (Egress Redirect to device ifb0) stolen
index 9 ref 1 bind 1


This is the first time I am reporting a bug, apologies if I am not
clear. My previous mails with formatting were marked as spam by the
mail Delivery
system and hence sending it in plain text. Happy to clarify if
required.

Thank You!

Best,
Sahitya Maruvada.
