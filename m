Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3356C8271
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCXQfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCXQfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:35:20 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E713D6C;
        Fri, 24 Mar 2023 09:35:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x17so2997514lfu.5;
        Fri, 24 Mar 2023 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679675717;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0oXkSV2sebAxHCIwL9LdQNQi2AqSegdoeaxnV09FF74=;
        b=kogiHFla6HqWUaWP00m/N4yDPNgETR/TJ5Gn2K7xfXBAQZK+Ds9zJRTfbWijnoIqAD
         s5PJ5tR7r8hVhWn2SnC8R4bgXjYQZEyCHOOUg67kuhV3GRn5IlWE24rmJRZoAjbx/e3f
         47kQcvaxW7xslYdM8k9KI3Ktg2+ASua7JBqI/ndexYPtFSvt8vCqeqvjyKHiDkZEJ5dP
         sYrPMGcNMfn5+9oN2CWXaeEZbIy0zAqRmMRBFS9olgl0prKwhvn+02JqtnBqnH9K79XH
         LC2AJRomYk5HAHiwaT7nPVK0PGjiEMXEb1iXkGqOFG9k4ovbV8vZNMnzPIQd+DikHmVg
         dPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679675717;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0oXkSV2sebAxHCIwL9LdQNQi2AqSegdoeaxnV09FF74=;
        b=qOCyXyEJkPZ9OqxIrF8Hj/uZuP+MOEQzv1DiGzq35GeQaQZYDHRu4hS3yekfdCe4Xa
         +PxujdVXj4mCQiKZSX2QDl0F8JmrteBWve+JYJ2vimRAjROs9aHkKjy2GfKVlMq/IOwT
         5bCZ5hk6YyTaL/rE4yufDvkfpB/10D1vxSlL4dUMqYuobvL2eKrqubQeLI3NNmRZlbxt
         S4Q4JnFejHRvM+SurX9VCevA7ikZbZlvnNxkMB/bcAKjndkSxvCAvOabOqRd7MRzcMi4
         f9E6/E2YjrUSwkki3yBJHxUtBytgSqDzUsM6M8Jf4pkkqbtAd2mCE3us2FPmkJk5tjDm
         viHQ==
X-Gm-Message-State: AAQBX9fs4PhynUSWX5QvQxxGFsjeYDPhJaKctvG+6fByNtmKKzp6aJr4
        Hng3icMfItNT+JmCBUkQ6lPkUl3Z2sp2M6VWzuiNSS27x9a4quZZ
X-Google-Smtp-Source: AKy350ZhMWyqnv3VWYo6wNSTJOCpj4B0nCXZQeOZl/ujitUH1P+TUXrU+I8Wk8LSzhm7wlQMd3Z6toMSqh/ptQ4fISE=
X-Received: by 2002:ac2:519c:0:b0:4e0:822f:9500 with SMTP id
 u28-20020ac2519c000000b004e0822f9500mr903777lfi.12.1679675716968; Fri, 24 Mar
 2023 09:35:16 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Fri, 24 Mar 2023 19:35:06 +0300
Message-ID: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
Subject: [BUG] gre interface incorrectly generates link-local addresses
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, a@unstable.cc,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainers,

I found that GRE arbitrarily hangs IP addresses from other interfaces
described in /etc/network/interfaces above itself (from bottom to
top). Moreover, this error occurs on both ip4gre and ip6gre.

Example of mgre interface:

13: mgre1@NONE: <MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc noqueue
state UNKNOWN group default qlen 1000
    link/gre 0.0.0.0 brd 0.0.0.0
    inet 10.10.10.100/8 brd 10.255.255.255 scope global mgre1
       valid_lft forever preferred_lft forever
    inet6 fe80::a0a:a64/64 scope link
       valid_lft forever preferred_lft forever
    inet6 fe80::7f00:1/64 scope host
       valid_lft forever preferred_lft forever
    inet6 fe80::a0:6842/64 scope host
       valid_lft forever preferred_lft forever
    inet6 fe80::c0a8:1264/64 scope host
       valid_lft forever preferred_lft forever

It seems that after the corrections in the following commits
https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b65be8cd4b5f
https://github.com/torvalds/linux/commit/30e2291f61f93f7132c060190f8360df52644ec1
https://github.com/torvalds/linux/commit/23ca0c2c93406bdb1150659e720bda1cec1fad04

in function add_v4_addrs() instead of stopping after this check:

if (addr.s6_addr32[3]) {
                add_addr(idev, &addr, plen, scope, IFAPROT_UNSPEC);
                addrconf_prefix_route(&addr, plen, 0, idev->dev, 0, pflags,
                                                                GFP_KERNEL);
                 return;
}

it goes further and in this cycle hangs addresses from all interfaces on the gre

for_each_netdev(net, dev) {
      struct in_device *in_dev = __in_dev_get_rtnl(dev);
      if (in_dev && (dev->flags & IFF_UP)) {
      struct in_ifaddr *ifa;
      int flag = scope;
      in_dev_for_each_ifa_rtnl(ifa, in_dev) {
            addr.s6_addr32[3] = ifa->ifa_local;
            if (ifa->ifa_scope == RT_SCOPE_LINK)
                     continue;
            if (ifa->ifa_scope >= RT_SCOPE_HOST) {
                     if (idev->dev->flags&IFF_POINTOPOINT)
                              continue;
                     flag |= IFA_HOST;
            }
            add_addr(idev, &addr, plen, flag,
                                    IFAPROT_UNSPEC);
            addrconf_prefix_route(&addr, plen, 0, idev->dev,
                                     0, pflags, GFP_KERNEL);
            }
}

Moreover, before switching to Debian 12 kernel version 6.1.15, I used
Debian 11 on 5.10.140, and there was no error described in the commit
https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b65be8cd4b5f.
One link-local address was always generated on the gre interface,
regardless of whether the destination or the local address of the
tunnel was specified.

Which linux distribution did you use when you found an error with the
lack of link-local address generation on the gre interface?
After fixing the error, only one link-local address is generated?
I think this is a bug and most likely the problem is in generating
dev->dev_addr, since link-local is formed from it.

I suggest solving this problem or roll back the code changes made in
the comments above.
