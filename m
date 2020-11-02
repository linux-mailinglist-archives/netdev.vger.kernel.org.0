Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87D72A3599
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKBUyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgKBUwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:52:15 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7E4C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:52:15 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o3so11797473pgr.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hz5JYQhftdiL+8xkVkW63SuIK7KBxZEGbZcTmIkLHhM=;
        b=QqDpctvy/g86WBCIS5lUc/MKxCAf6W47KP5HBISaKK5QrozRk8fE4OtLYTJXqxwDu7
         x44givZkjmDevh8Qho0H1XLatZuhd6EnOSJil33QdbCo49GIpU8+YHVhsu4r83Ze8CMA
         swlit2hMja/JWAHoaMG1wjWt7VGE4yIwvD/ugzKqgTH5Ogto1PlTImeZ4xzGrkwwBh9S
         QoMXwu+htB+9UrMaYHYZuDqV3Ai6m7s3fkJNYgIzKUjXC+3lGmIxEBZNAKgTxuVXlpdn
         2RmlAoclEdLGWrQ0UqoJVIEFxT03JZs2XasHL85DKo5aRxUtgn4qonKtJ8/bAp7aVyov
         ZGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hz5JYQhftdiL+8xkVkW63SuIK7KBxZEGbZcTmIkLHhM=;
        b=oBu+R0dzOnqgNK1qo+cIb53YeBhtorkcez42RjZBfeAbHzMoKFL1aHn0QltgHkJUCi
         MXkBEUymqWYbQxsCQaHMBYbHU2bD7gw8I6LelK0QuyR9FMCQOV1GhWX62/Pi6uS7yE4M
         eF3NI1IYCIcZAHUQnwCPk4pZhtvoNv13foJALgiLJ+r45ShLDgcqdo4GXzw3RjaXkRTR
         41m2POdg6jIat6xJQfvVjFuIsVzdgN8LvmgxY4h/Uue6BrswImyvwAaQBwulpKYVTUP6
         YZSCbb61kDl6KNSk8El9v/vNYBYOiuhTQ8DwneRYpjDFiSnbydRvr0mxbClxU/yUXD1U
         K4qA==
X-Gm-Message-State: AOAM533Tsg+agxee0jt1Xz8xnwA7MxTXVi918nqHcRtDlWYCfXrwgoDk
        plhhh1P4w+pKimDvpTszUbM=
X-Google-Smtp-Source: ABdhPJySNLJ53H2rU8T1DkSh1HGTYjGT7KHX2m4q4B7OSiE4Es7sFx6bqOmxu/rFnufEDSuAcQcjtQ==
X-Received: by 2002:aa7:96d7:0:b029:18a:b62f:3527 with SMTP id h23-20020aa796d70000b029018ab62f3527mr11675817pfq.53.1604350334610;
        Mon, 02 Nov 2020 12:52:14 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n125sm9017636pfn.127.2020.11.02.12.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:52:13 -0800 (PST)
Subject: Re: [PATCH v3 net-next 10/12] net: dsa: tag_dsa: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-11-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <780eb021-17af-130d-5d49-56ab3eac7d7b@gmail.com>
Date:   Mon, 2 Nov 2020 12:52:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Similar to the EtherType DSA tagger, the old Marvell tagger can
> transform an 802.1Q header if present into a DSA tag, so there is no
> headroom required in that case. But we are ensuring that it exists,
> regardless (practically speaking, the headroom must be 4 bytes larger
> than it needs to be).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
