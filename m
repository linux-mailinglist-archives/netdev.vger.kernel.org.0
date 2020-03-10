Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7E317EF67
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgCJDo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:44:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38447 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgCJDo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 23:44:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id e20so8727996qto.5
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 20:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KIz4eb/MtfXiUgKFzz+5JsULpIMiYHTfDdmoTnFgq1U=;
        b=dV1euwDX7Z/XDC0VP22DZzOmL9xDhb8r59Wn11ikpIdrGsseeXRlyp3GkhKAmVE4sY
         LA/0XTzL86tIbJKqQMYV1F8BsId9MeC7yqNap2TKZ4HVCRwea6RRbQQUJR3R/04ikn3h
         dvXX9ros5Z5I/vQpd4+WMoU0ouqiM+GEHXd8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KIz4eb/MtfXiUgKFzz+5JsULpIMiYHTfDdmoTnFgq1U=;
        b=ibw/uTbJ3+gr7+Lc2g7tfn9mAW9wDxWPkS/0z0e0vZIx1E3/qNcqFNDzuqS55L5AU/
         OSpkNS1QFhUwlBDzcLXOVsIukRMChr0eSaQ+3IR016hDXnyLXTybIcSzGVA2zkpRrz5F
         sNNMDsuR5Q9+7XNnrO8VVj6InbowT1l/iuXsQoVFpCzBgj5fSoqUd8l71EzFcx+hkJz5
         9RFlFVKqP4vsLVqi+3VMaKwaBICUE2lq3ls8HT95YsQiQUGajzklBYcJ07dacRO7jigQ
         gl2fge+ljU7l5vftmwlfOZyq/xjNnhKhyr6tuQffve3nUyw1H0VPZs6QHiXfQ8Jjb88n
         +Awg==
X-Gm-Message-State: ANhLgQ2m4zA5x+Jc5a0g0AoTUtlNHF1jyvC+yMjB84YnhaL0EF+Mxe6V
        kvahzdQ0NBBN2ETN183i98xDoQ==
X-Google-Smtp-Source: ADFU+vsaMyMnfFWrR/kX5x33KK/nA9xAbvcUFwR+IItwtre8kYFOwiLMCUWxRQw+lSWc2nsYTp8BSw==
X-Received: by 2002:ac8:1194:: with SMTP id d20mr17286130qtj.243.1583811865769;
        Mon, 09 Mar 2020 20:44:25 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.gmail.com with ESMTPSA id y62sm23216113qka.19.2020.03.09.20.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 20:44:25 -0700 (PDT)
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path for
 xdp_frames
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-10-dsahern@kernel.org> <20200303114044.2c7482d5@carbon>
 <14ef34c2-2fa6-f58c-6d63-e924d07e613f@digitalocean.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <942c9efd-67e2-65d3-d311-bb4eba9fb747@digitalocean.com>
Date:   Mon, 9 Mar 2020 21:44:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <14ef34c2-2fa6-f58c-6d63-e924d07e613f@digitalocean.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 9:06 PM, David Ahern wrote:
> Why do I need to make any adjustments beyond what is done by
> bpf_xdp_adjust_head and bpf_xdp_adjust_tail?

never mind. forgot the switch from xdp_frame to xdp_buff there so need
to go back to frame.
