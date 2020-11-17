Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21772B55D4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbgKQApF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgKQApE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:45:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2075824682;
        Tue, 17 Nov 2020 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605573904;
        bh=06jblf0tzRJ08jMztos5luGT1Zgly8HSetaL/BmSdwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LFJYqnqMbmfysww4TC06viz9xlubCUHegAm07Z2L4He2+wS/KsOlaiXe+AhEmIB+1
         0ki0oCSVofpe4+PSVCpxqfIBv4p0eZbhlh1Lzg1uPNU3TF7zCdwihKwbe6o8CaYaHn
         AmVzhqO5O7C/dwYkn1XwHjOc+7tHiTJkjjgM80/o=
Date:   Mon, 16 Nov 2020 16:45:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 4/4] selftests: add ring and coalesce
 selftests
Message-ID: <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113231655.139948-4-acardace@redhat.com>
References: <20201113231655.139948-1-acardace@redhat.com>
        <20201113231655.139948-4-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 00:16:55 +0100 Antonio Cardace wrote:
> Add scripts to test ring and coalesce settings
> of netdevsim.
> 
> Signed-off-by: Antonio Cardace <acardace@redhat.com>

> @@ -0,0 +1,68 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +source ethtool-common.sh
> +
> +function get_value {
> +    local key=$1
> +
> +    echo $(ethtool -c $NSIM_NETDEV | \
> +        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
> +}
> +
> +if ! ethtool -h | grep -q coalesce; then
> +    echo "SKIP: No --coalesce support in ethtool"
> +    exit 4

I think the skip exit code for selftests is 2

> +fi
> +
> +NSIM_NETDEV=$(make_netdev)
> +
> +set -o pipefail
> +
> +declare -A SETTINGS_MAP=(
> +    ["rx-frames-low"]="rx-frame-low"
> +    ["tx-frames-low"]="tx-frame-low"
> +    ["rx-frames-high"]="rx-frame-high"
> +    ["tx-frames-high"]="tx-frame-high"
> +    ["rx-usecs"]="rx-usecs"
> +    ["rx-frames"]="rx-frames"
> +    ["rx-usecs-irq"]="rx-usecs-irq"
> +    ["rx-frames-irq"]="rx-frames-irq"
> +    ["tx-usecs"]="tx-usecs"
> +    ["tx-frames"]="tx-frames"
> +    ["tx-usecs-irq"]="tx-usecs-irq"
> +    ["tx-frames-irq"]="tx-frames-irq"
> +    ["stats-block-usecs"]="stats-block-usecs"
> +    ["pkt-rate-low"]="pkt-rate-low"
> +    ["rx-usecs-low"]="rx-usecs-low"
> +    ["tx-usecs-low"]="tx-usecs-low"
> +    ["pkt-rate-high"]="pkt-rate-high"
> +    ["rx-usecs-high"]="rx-usecs-high"
> +    ["tx-usecs-high"]="tx-usecs-high"
> +    ["sample-interval"]="sample-interval"
> +)
> +
> +for key in ${!SETTINGS_MAP[@]}; do
> +    query_key=${SETTINGS_MAP[$key]}
> +    value=$((RANDOM % $((2**32-1))))
> +    ethtool -C $NSIM_NETDEV "$key" "$value"
> +    s=$(get_value "$query_key")

It would be better to validate the entire config, not just the most
recently set key. This way we would catch the cases where setting
attr breaks the value of another.

> +    check $? "$s" "$value"
> +done
