Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A92B5E69
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKQLcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:32:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKQLcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 06:32:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605612764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RzX3RJ5kwF/FnKh7HUdpW9ixuOHF+eQ6xVhv9w/a4tY=;
        b=GgUo1bGcLoO+EC7ZdgUCFjPXpnU5i27jjRjWn5CIzcZMlACOb+tFsKbthxPpcYfCOjTK10
        ZtViOxng+HH+KvLLCGeRqCzmrOJC2y5J0jVzEI7bpSgnbRTvTk17DYuCNd9w0d9e9vNBAP
        pq5ya+bbgyrI4kMwzulJK/rf9bcITIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-9PAx6R_IM7-L3Ns7QPg3TQ-1; Tue, 17 Nov 2020 06:32:41 -0500
X-MC-Unique: 9PAx6R_IM7-L3Ns7QPg3TQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C1DB1008304;
        Tue, 17 Nov 2020 11:32:40 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0793C60C05;
        Tue, 17 Nov 2020 11:32:38 +0000 (UTC)
Date:   Tue, 17 Nov 2020 12:32:36 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 4/4] selftests: add ring and coalesce
 selftests
Message-ID: <20201117113236.yqgv3q5csgq3vwqr@yoda.fritz.box>
References: <20201113231655.139948-1-acardace@redhat.com>
 <20201113231655.139948-4-acardace@redhat.com>
 <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 04:45:03PM -0800, Jakub Kicinski wrote:
> On Sat, 14 Nov 2020 00:16:55 +0100 Antonio Cardace wrote:
> > Add scripts to test ring and coalesce settings
> > of netdevsim.
> > 
> > Signed-off-by: Antonio Cardace <acardace@redhat.com>
> 
> > @@ -0,0 +1,68 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +
> > +source ethtool-common.sh
> > +
> > +function get_value {
> > +    local key=$1
> > +
> > +    echo $(ethtool -c $NSIM_NETDEV | \
> > +        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
> > +}
> > +
> > +if ! ethtool -h | grep -q coalesce; then
> > +    echo "SKIP: No --coalesce support in ethtool"
> > +    exit 4
> 
> I think the skip exit code for selftests is 2
In the ethtool-pause.sh selftest the exit code is 4 (I copied it from
there), should I change that too?
> 
> > +fi
> > +
> > +NSIM_NETDEV=$(make_netdev)
> > +
> > +set -o pipefail
> > +
> > +declare -A SETTINGS_MAP=(
> > +    ["rx-frames-low"]="rx-frame-low"
> > +    ["tx-frames-low"]="tx-frame-low"
> > +    ["rx-frames-high"]="rx-frame-high"
> > +    ["tx-frames-high"]="tx-frame-high"
> > +    ["rx-usecs"]="rx-usecs"
> > +    ["rx-frames"]="rx-frames"
> > +    ["rx-usecs-irq"]="rx-usecs-irq"
> > +    ["rx-frames-irq"]="rx-frames-irq"
> > +    ["tx-usecs"]="tx-usecs"
> > +    ["tx-frames"]="tx-frames"
> > +    ["tx-usecs-irq"]="tx-usecs-irq"
> > +    ["tx-frames-irq"]="tx-frames-irq"
> > +    ["stats-block-usecs"]="stats-block-usecs"
> > +    ["pkt-rate-low"]="pkt-rate-low"
> > +    ["rx-usecs-low"]="rx-usecs-low"
> > +    ["tx-usecs-low"]="tx-usecs-low"
> > +    ["pkt-rate-high"]="pkt-rate-high"
> > +    ["rx-usecs-high"]="rx-usecs-high"
> > +    ["tx-usecs-high"]="tx-usecs-high"
> > +    ["sample-interval"]="sample-interval"
> > +)
> > +
> > +for key in ${!SETTINGS_MAP[@]}; do
> > +    query_key=${SETTINGS_MAP[$key]}
> > +    value=$((RANDOM % $((2**32-1))))
> > +    ethtool -C $NSIM_NETDEV "$key" "$value"
> > +    s=$(get_value "$query_key")
> 
> It would be better to validate the entire config, not just the most
> recently set key. This way we would catch the cases where setting
> attr breaks the value of another.
> 
Good idea, will do.

Thanks,
Antonio

