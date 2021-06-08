Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE039FDDF
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhFHRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhFHRjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:39:40 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325DAC061789
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 10:37:47 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so21132220otl.3
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=mf0cOm6a9lH9rthgxSvnKitToPRlx8kXWIj/JtvwTK8=;
        b=oHNotyRvil+Z2mqPXh20bYqBDFwb5Z6cvvndqUQ/MfPwzlQIw1l8kwKmJBvy9e5XfL
         4nuLOrisd6Aq2dNOdtL+LOm4FKydRD3thFr8bJLf4nRjYHScdZ/bU1A1vDK83RGKvytH
         +x6O0Yz9obeW1RTP9VJ1KPK/Ww+NTeFjVhwQ99GkZpPTMTyZJdw+CcIhYCM1Nnr6k5qa
         2GzTw3wpOaInvun6U2bCgNnMv/k2AzczD5rXICb7yB+V6T/auw8uSQfNF58R9olkSjJr
         bzJeDtnANfrDnrJQcqw/6ZhEp5Z4c8jtHaO2tYZY1fwVWAOAS7vtpJ17Jp6D3s3Z0/TG
         4l/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mf0cOm6a9lH9rthgxSvnKitToPRlx8kXWIj/JtvwTK8=;
        b=j89mAwqZR8nUn+ywAee5xdMMVQ7CZs9wahcOr5gkGhyaniMrVD+exXaKhbD14uutgM
         B3A1bLcXL0h9RtwNTdW1Re9l+y/2ABfQ0KLW6rkIpKGHzOTKoWiMHxxEpzKFHNZeCYRA
         Ow/zHCmcysizl9sY3O+ckWv+bjA3c/Oeukl5Ve+22trpFwNPgH2drE39m8ab+2kX9ynC
         TEDwOkFF9nO9BQTFRJsQtjPMLTROUHhefeBBLhPt+NwpnT0NduCC9RUCD9uF/MaFkMV0
         irTyUybe4RZBWHlgPdkYFhi0hBAnI+oWXtSvJXYFEjO8nksFYICG19c6ocQ2MQAr8jYt
         EwXg==
X-Gm-Message-State: AOAM530bdcudwKuxDQM5XWHKlgkoREJI8IQ1x+GjHcJ+b31pajeTAeRW
        Ub2SLo/oL1inX92ffkAXu4e+UzhAt9S+dAxIJJNiIeOzjd+fmg==
X-Google-Smtp-Source: ABdhPJwGifw4XBwE/KLHMfRanS8qpmWv9/QN/p8nQVmo+M+GKMxKWkFOiMit9qPiH0eufcREXN3TTq6DAGjm9FGAjH8=
X-Received: by 2002:a05:6830:119a:: with SMTP id u26mr19634221otq.87.1623173866188;
 Tue, 08 Jun 2021 10:37:46 -0700 (PDT)
MIME-Version: 1.0
From:   Lalitha Sahitya Maruvada <sahitya.lalitha@gmail.com>
Date:   Tue, 8 Jun 2021 10:37:35 -0700
Message-ID: <CAFxY_Ev-q+Q3Dhx45g6HMiEYDGkr_D-QqKi_zdf0kq_OCY0yaQ@mail.gmail.com>
Subject: 
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
clear. My mail with formatting was marked as spam by the mail Delivery
system and hence sending it in plain text. Happy to clarify if
required.

Thank You!



Best,
Sahitya Maruvada.
