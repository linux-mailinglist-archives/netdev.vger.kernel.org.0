Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3607816F61B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgBZDcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:32:18 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:40162 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgBZDcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:32:18 -0500
Received: by mail-qt1-f178.google.com with SMTP id v25so1275431qto.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 19:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZGzY/UDwkfANEdStQ8NTFLEjfeGHZNS1ZW30/0joxnQ=;
        b=Tu5Pz47SNhbUyctJwlVlvgrBASsKjQ/5pALPf3j5OQ2WUGim/PoOzewtiv+DCPGJxs
         ky+HjrvuZ9dG20Y4Wp+mGZauroa6sWnmqKOJ1D36bXiIi2ahZ+NfMZoRbs2RuEK6lweZ
         vvfOVoBJm9BvxksUQ4OmEb/HWf56llfMwnAz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZGzY/UDwkfANEdStQ8NTFLEjfeGHZNS1ZW30/0joxnQ=;
        b=YkSbXQ7LKBTWl5YOu8TzHRnCwfmlycVSxXNMp4OimJA9F6hE/SVTvwSyMz3G/TJJbZ
         qpJ/8xfHev71Lqmt+cElkBaxcUn9KVepant0mqpWwpFXzWGBgwS+hn4Hxc+IQtBTeG2y
         7YWiq/RcLGUYFCpM4ZvKcTg9AnvAU3nGmNjv5rvsN0cbsGTy3i4rYmgYqDmuGt8jd3uP
         OIgSMo+yQWsDrZxbtAQDdFUD+37R8mczMGPax70dKhOzBXv8tMqpoMOsUfKe5JGs+tu9
         R+x5XFd0/s6otkgsyuFt/G55f7TW4XchmR0Ba9wzwitWO8bIxLO8x/c7DVna6DHZYIYn
         2F2g==
X-Gm-Message-State: APjAAAUx12CNMrT6WYmbb/q9CjbO/oK+Soz+BGqCujcUoU3rLvuhOoZt
        zWbxf4qqAgaEjHMJ2SojRQMqIcVSMU17Bg==
X-Google-Smtp-Source: APXvYqzlXAFy2tLKNTFb4txKqxY6Wvu2UBs0m5euwjDpA7gKktlXRLuFqG3TYZxF6zjxX7wwE7dRFg==
X-Received: by 2002:aed:3fa3:: with SMTP id s32mr1298551qth.10.1582687937344;
        Tue, 25 Feb 2020 19:32:17 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4f3:14fb:fa99:757f? ([2601:282:803:7700:e4f3:14fb:fa99:757f])
        by smtp.gmail.com with ESMTPSA id l8sm359316qtr.36.2020.02.25.19.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 19:32:16 -0800 (PST)
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   David Ahern <dahern@digitalocean.com>
Subject: virtio_net: can change MTU after installing program
Message-ID: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
Date:   Tue, 25 Feb 2020 20:32:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another issue is that virtio_net checks the MTU when a program is
installed, but does not restrict an MTU change after:

# ip li sh dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
state UP mode DEFAULT group default qlen 1000
    link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
    prog/xdp id 13 tag c5595e4590d58063 jited

# ip li set dev eth0 mtu 8192

# ip li sh dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
state UP mode DEFAULT group default qlen 1000


The simple solution is:

@@ -2489,6 +2495,8 @@ static int virtnet_xdp_set(struct net_device *dev,
struct bpf_prog *prog,
                }
        }

+       dev->max_mtu = prog ? max_sz : MAX_MTU;
+
        return 0;

 err:

The complicated solution is to implement ndo_change_mtu.

The simple solution causes a user visible change with 'ip -d li sh' by
showing a changing max mtu, but the ndo has a poor user experience in
that it just fails EINVAL (their is no extack) which is confusing since,
for example, 8192 is a totally legit MTU. Changing the max does return a
nice extack message.
