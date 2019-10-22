Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3DDDF9EE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 02:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfJVAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 20:51:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38102 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbfJVAvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 20:51:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id o25so10791252qtr.5;
        Mon, 21 Oct 2019 17:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UgHNrnh51LB6rsCCFN3sZSSt5cfq2Pvtlch4dtYv1tA=;
        b=FDCkswBoPdusvkkQyAi0DqMRQ9KngFpAG+MZPS8AhwUjkAT8Fg3UwFa/qlaN0BlOZP
         ucN3naXBSANDhjFQkE0iX+eyY3Y3GRifwfnQ6tsI+yrMcnlcg4SlJFDHc1DnZGq5bt+C
         8xo0naNKxUG1EaXFer3+jR+0m3zxROC+NDrH47/yP7H7y4Wtu6TM+nn+d/opZWvUtwr0
         kmf8BNVt1+ee25+MIKuBcp/sk34b/XovxFo/IUSOnUvuDMg82uz6rf4TSSOFT5FgLcZ6
         8CnA3MjDkZJDgMsXQQQdS+faDQsSk0zHPV0q1jqRPzIRuLGjYKx7kRj3I/MGPZpYsj4d
         +W2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UgHNrnh51LB6rsCCFN3sZSSt5cfq2Pvtlch4dtYv1tA=;
        b=isW+k4/Bjdstr+TCG9opwdps5pahxMojKEddLdmJ20REVoOxE/ffi2WqXkImu7u5dF
         HspzJZakJrpXIJH7HX7MMwcgI5P5nffhS4DDO8CRMTEMIY9kJnoOgCZ1z9bLIlC9zHVi
         6f1GdXMmyXNwTMalKWli5WVEku51ZMk85c6KTSc5I/BJ6vYP9+qcfM06zQUc20IAA09t
         fs3+f/fJxAHegFN1jCR4fGHjJEcxAN/YkDp9LOJ2Bd+7yeEvJUk/0iRIaUWhhI9PfYBr
         NAZ02ed40+MVTqm7ek7fnxXZFu+qwyd9xrgRpYc5XMyw0w6VrNYOGS66HIBy10rJyh6L
         pfTA==
X-Gm-Message-State: APjAAAUTTU8J/i5u6zObBYS/MMaGhyMhnkLkMP7RnAFx4Pual4hv1U9G
        +1OQLNgrRKMFQ0QdJt0SJ2A=
X-Google-Smtp-Source: APXvYqxYjd0Zi1qjHa8UGioJLYyhNTYMQQASxvsQpy+HH86ZA+573b8Qsy/j+Geh8Ny+S3nN1XO8fA==
X-Received: by 2002:a05:6214:104b:: with SMTP id l11mr539620qvr.195.1571705476013;
        Mon, 21 Oct 2019 17:51:16 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b912:7de9:ffc9:d1c])
        by smtp.googlemail.com with ESMTPSA id r36sm6006903qta.27.2019.10.21.17.51.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 17:51:14 -0700 (PDT)
Subject: Re: [PATCH net v5 01/10] net: core: limit nested device depth
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, johannes@sipsolutions.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@resnulli.us, sd@queasysnail.net, roopa@cumulusnetworks.com,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        stephen@networkplumber.org, sashal@kernel.org, hare@suse.de,
        varun@chelsio.com, ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
References: <20191021184759.13125-1-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0e17051-ab18-ac60-9c00-348cce84d12f@gmail.com>
Date:   Mon, 21 Oct 2019 18:51:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 12:47 PM, Taehee Yoo wrote:
> Current code doesn't limit the number of nested devices.
> Nested devices would be handled recursively and this needs huge stack
> memory. So, unlimited nested devices could make stack overflow.
> 
> This patch adds upper_level and lower_level, they are common variables
> and represent maximum lower/upper depth.
> When upper/lower device is attached or dettached,
> {lower/upper}_level are updated. and if maximum depth is bigger than 8,
> attach routine fails and returns -EMLINK.
> 
> In addition, this patch converts recursive routine of
> netdev_walk_all_{lower/upper} to iterator routine.

They were made recursive because of a particular setup. Did you verify
your changes did not break it? See commits starting with
5bb61cb5fd115bed1814f6b97417e0f397da3c79

> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add link dummy0 name vlan1 type vlan id 1
>     ip link set vlan1 up
> 
>     for i in {2..55}
>     do
> 	    let A=$i-1
> 
> 	    ip link add vlan$i link vlan$A type vlan id $i
>     done
>     ip link del dummy0

8 levels of nested vlan seems like complete nonsense. Why not just limit
that stacking and not mess with the rest which can affect real use cases?
