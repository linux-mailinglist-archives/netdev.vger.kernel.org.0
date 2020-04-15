Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D471AB040
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411659AbgDOR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 13:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407096AbgDOR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 13:59:19 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E496FC061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 10:59:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a43so6128863edf.6
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 10:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4YUFNITzuK7wgC7XT8WM74MpY9NN1VUY2WpHvT4wKI4=;
        b=e1lprVRhZcWDtD8SxMdOgRZxZu+Jl3L2JK0mELg7Kfc9EDuSLhQosfxx73jLnOXpUk
         u5kMeYl5kYZg84jLhKZSMHNYFD3qlcUig1NGV729qnZqNaya+3rXXpjHwyWOxZua2AO5
         Mz50Xswt97Rw4gZJTWDprx+7dSBzfS4zfHiCRLiUDz8CSRrPYSxQyQD1Nkj/snBa/8EY
         IXZ3PGxwOHNQwyDdL8x6ZDpG9d+gpWUVd3dTHth/I98dypgFFktrZUjxQKoxw2rHJMOh
         Io7v4fHJXHMDqsXmSCGEnMi8lTgRxZgG8G5dprbKN5NxP6fUrAVLjixouu35ul9S43oR
         ilDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4YUFNITzuK7wgC7XT8WM74MpY9NN1VUY2WpHvT4wKI4=;
        b=UJBO3CJHYAKA27T9aQOEcHAAOAp0QUTZo6FLl9aLTm+uCFpzlHRGDv0utpCgcCZmy6
         Xe0VyZ6QwiaGPJH16IuE+gfrZMlwBXC+9wUv8f2yxlsdn+UA4V8UY/qhZ1CFb0/xasJ3
         oWZ1QVf4A0VI2mHctdwAc5JMCaDv+RMRpFCpq6V5Q7xk/35Pgo/I7Z3fh04gdW4DvSkc
         m3/RtwtEUl9kZY2WUtCxoGbBby/CjWjWSSvrBPjw+WL9NSsLwI1F+GPKL3PXXTjTfPFu
         /iyItUSsO4XPlwn3eyX3mNt+L+SDjnHtXCh/otf+TaDdH1RzkrYNc5octaeK9DOGIUGV
         76cQ==
X-Gm-Message-State: AGi0PuZ37/TlS7BZQeFd8z4faE3cbONQcRhmsY7Gl8zA8oerO3bA2sR0
        plQull16V7Prj4uqJjFFTXJRoWZdCpAwHIQX6PU=
X-Google-Smtp-Source: APiQypJuEYo/AFyzN4ipw8ZOkFugd1kUQY1V1JbdOsgN18fhboriR7yxt8/0jSU2TXBekkoP41RCiVj9oSXOzNVnnOM=
X-Received: by 2002:a50:d1d7:: with SMTP id i23mr27282704edg.118.1586973557631;
 Wed, 15 Apr 2020 10:59:17 -0700 (PDT)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 15 Apr 2020 20:59:06 +0300
Message-ID: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
Subject: Correct tc-vlan usage
To:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to use tc-vlan to create a set of asymmetric tagging
rules: push VID X on egress, and pop VID Y on ingress. I am using
tc-vlan specifically because regular VLAN interfaces are unfit for
this purpose - the VID that gets pushed by the 8021q driver is the
same as the one that gets popped.
The rules look like this:

# tc filter show dev eno2 ingress
filter protocol 802.1Q pref 49150 flower chain 0
filter protocol 802.1Q pref 49150 flower chain 0 handle 0x1
  vlan_id 103
  dst_mac 00:04:9f:63:35:eb
  not_in_hw
        action order 1: vlan  pop pipe
         index 6 ref 1 bind 1

filter protocol 802.1Q pref 49151 flower chain 0
filter protocol 802.1Q pref 49151 flower chain 0 handle 0x1
  vlan_id 102
  dst_mac 00:04:9f:63:35:eb
  not_in_hw
        action order 1: vlan  pop pipe
         index 5 ref 1 bind 1

filter protocol 802.1Q pref 49152 flower chain 0
filter protocol 802.1Q pref 49152 flower chain 0 handle 0x1
  vlan_id 101
  dst_mac 00:04:9f:63:35:eb
  not_in_hw
        action order 1: vlan  pop pipe
         index 4 ref 1 bind 1

# tc filter show dev eno2 egress
filter protocol all pref 49150 flower chain 0
filter protocol all pref 49150 flower chain 0 handle 0x1
  dst_mac 00:04:9f:63:35:ec
  not_in_hw
        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
         index 3 ref 1 bind 1

filter protocol all pref 49151 flower chain 0
filter protocol all pref 49151 flower chain 0 handle 0x1
  dst_mac 00:04:9f:63:35:eb
  not_in_hw
        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
         index 2 ref 1 bind 1

filter protocol all pref 49152 flower chain 0
filter protocol all pref 49152 flower chain 0 handle 0x1
  dst_mac 00:04:9f:63:35:ea
  not_in_hw
        action order 1: vlan  push id 102 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1

My problem is that the VLAN tags are discarded by the network
interface's RX filter:

# ethtool -S eno2
     SI VLAN nomatch u-cast discards: 1280

and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
(only the 8021q driver does). This makes me think that I am using the
tc-vlan driver incorrectly. What step am I missing?

Thanks,
-Vladimir
