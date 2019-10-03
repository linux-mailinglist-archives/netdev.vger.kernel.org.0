Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AB7CAB41
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390698AbfJCRTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:19:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34792 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389757AbfJCRTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:19:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id y35so2188988pgl.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSOHCKBJNtLOj6cAWtlDD/1kzMIO7KD0b1UvCFx3sls=;
        b=acYJ/CvX9FBRpGmBelhhBa+qkmuBUWvggWfE0ErkHcneNQgvKBhjClyfbFuKsUjKMd
         TAxb91MywN/TlTIo0COukVFX3CCrFmD5s2EInYfheWdiwY9WRC13NBGQu7gx1hVTnQHR
         QlJxXFE0J526FIDV7VZpkcisf70uOdC7MNfg/RRcctPd1IEWI0Pc1fF6A+sewUqu0a+o
         sVcgqKy6D0SJesngfUp+X0oXXQGcdfpwwHwfOsJXOCzzQiJ3Cg/fIlsdqLlKlme51EHM
         HrdJGdPtAagJOntZZvChf8BGQbZBOcTQqsLaeZBevPs5AvAFwkN5NEFtGRIsq+RPnAU0
         wy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSOHCKBJNtLOj6cAWtlDD/1kzMIO7KD0b1UvCFx3sls=;
        b=qdihfMcZ7qxJj7o8//UxUe1Tu9uT9HtASdbZLCSp5JIoYcL3ov22bXjZW80gTb4Feh
         q655187GKi6Wm9RKztnWdmE81idlinCaRzmrMJIX/A2KrGd92cZde+FbkZOBsOJQCPQR
         U205Uz2PYvrmWHw0UP4ciGVXSKeuYEUt+bcjkmITAw7gBmnt/t5sCTOAAcIK/8+AalSF
         nv/tWrZHwVT431Inv6dX2dh3szr301KJQsASB93VafvKsKvMAzkuYaFFKRzJls19YP2V
         SsO+2Rj1/Gi8XSKcAha4gGFdt0WIoVxe/MbZAJNR86SfgKdYjGA+QIIdzTyQ7lmJ4Tsw
         Y6tw==
X-Gm-Message-State: APjAAAXGwLef5jA/ibEREBema+2Hbhd86KASzPNBpdSLrMVGxiYeZm38
        CoC7OQ7607+V11sLwE5vcV0=
X-Google-Smtp-Source: APXvYqxKGkD7WoUa4xmwiqI5xgAUcs3DAO7Au3SilajPckSJSM77cL/BrkrOVBIqk8ww+8BmBwACAA==
X-Received: by 2002:a17:90a:fa3:: with SMTP id 32mr11947080pjz.35.1570123172887;
        Thu, 03 Oct 2019 10:19:32 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id z20sm2516706pjn.12.2019.10.03.10.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 10:19:32 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <4c896029-882f-1a4f-c0cc-4553a9429da3@gmail.com>
 <43e2c04f-a601-3363-1f98-26fd007be960@gmail.com>
Message-ID: <0471f2fd-c472-34c1-5dab-0aa01c837322@gmail.com>
Date:   Thu, 3 Oct 2019 10:19:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <43e2c04f-a601-3363-1f98-26fd007be960@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/19 9:32 AM, Eric Dumazet wrote:
> 

> 
> Still no luck for me :/
> 

One of the failing test was :

unshare -n
./traceroute_test.sh -I icmp


$ cat ./traceroute_test.sh
#!/bin/bash
#
# Test traceroute.
#
# This is a test to run traceroute with the given parameters. It sets up three
# containers, source, router, and destination, connected via two pairs of veth:
#
#  source veth0src<-->veth0rtr router veth1rtr<-->veth1dst destination
#
# Then it runs traceroutes from source to destination in the source container.

set -Euex

readonly src="src-$$"
readonly rtr="rtr-$$"
readonly dst="dst-$$"

readonly SRC_IP6='2002:a00:1::1/24'
readonly DST_IP6='2002:b00:1::1/24'
readonly RTR_SRC_IP6='2002:a00:1::2/24'
readonly RTR_DST_IP6='2002:b00:1::2/24'
readonly SRC_NET6='2002:a00::/24'
readonly DST_NET6='2002:b00::/24'
readonly SRC_IP4='10.0.1.1/24'
readonly DST_IP4='10.0.2.1/24'
readonly RTR_SRC_IP4='10.0.1.2/24'
readonly RTR_DST_IP4='10.0.2.2/24'

init() {
  ip netns add "${src}"
  ip netns add "${rtr}"
  ip netns add "${dst}"

  ip link add veth0rtr type veth peer name veth0src
  ip link add veth1rtr type veth peer name veth1dst
  ip link set veth0rtr netns "${rtr}"
  ip link set veth0src netns "${src}"
  ip link set veth1rtr netns "${rtr}"
  ip link set veth1dst netns "${dst}"
}

setup() {
  local -r NS="$1"
  local -r IF="$2"
  local -r IP4="$3"
  local -r IP6="$4"

  ip -n "${NS}" link set lo up

  ip -n "${NS}" link set "${IF}" up
  ip -n "${NS}" -4 addr add "${IP4}" dev "${IF}"
  ip -n "${NS}" -6 addr add "${IP6}" dev "${IF}" nodad
  ip netns exec "${NS}" sysctl net.ipv4.conf.all.forwarding=1
  ip netns exec "${NS}" sysctl net.ipv6.conf.all.forwarding=1
}

route() {
  ip -n "${src}" route add default via "${RTR_SRC_IP4%/*}"
  ip -n "${dst}" route add default via "${RTR_DST_IP4%/*}"

  ip -n "${rtr}" -6 route add "${SRC_NET6}" dev veth0rtr
  ip -n "${rtr}" -6 route add "${DST_NET6}" dev veth1rtr
  ip -n "${src}" -6 route add default dev veth0src
  ip -n "${dst}" -6 route add default dev veth1dst
  ip -n "${src}" -6 route add "${DST_NET6}" via "${RTR_SRC_IP6%/*}"
  ip -n "${dst}" -6 route add "${SRC_NET6}" via "${RTR_DST_IP6%/*}"
}

fini() {
  set +e

  # Run ping and ping6 to have reachability data in the logs, in case the
  # test fails. We want to know that whether a failure is casued because of
  # a regression for traceroute.
  ip netns exec "${src}" ping "${DST_IP4%/*}" -c 3
  ip netns exec "${src}" ping6 "${DST_IP6%/*}" -c 3

  ip netns del "${src}"
  ip netns del "${rtr}"
  ip netns del "${dst}"
}

chk_traceroute() {
  if [[ "$(grep '*' | wc -l)" != "0" ]]; then
    echo 'FAILED'
    exit 1
  fi
}

main() {
  trap fini EXIT

  init

  setup "${src}" veth0src "${SRC_IP4}" "${SRC_IP6}"
  setup "${dst}" veth1dst "${DST_IP4}" "${DST_IP6}"
  setup "${rtr}" veth0rtr "${RTR_SRC_IP4}" "${RTR_SRC_IP6}"
  setup "${rtr}" veth1rtr "${RTR_DST_IP4}" "${RTR_DST_IP6}"

  route

  sleep 1

  ip netns exec "${src}" traceroute "${DST_IP4%/*}" "$@" -4 -n -m 2 -z 1 | \
      chk_traceroute
  ip netns exec "${src}" traceroute "${DST_IP6%/*}" "$@" -6 -n -m 2 -z 1 | \
      chk_traceroute
  echo 'PASSED'
}

main "$@"; exit

