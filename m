Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536B91F924A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgFOIyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:54:35 -0400
Received: from mout.web.de ([212.227.15.4]:51897 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbgFOIyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 04:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592211249;
        bh=8kiclZYo4jXkElPbwv3WBlLcVhLVTrcSqSXXxlnioVo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=o5aA/uMf2NYJEv/kKk9zdbOPoHDCrE5AVg0Rq+fgjZIM1B07YQP9IumaMBWDLX8kX
         0oaaTYPQ8teAgfk7U1ZL/NgBoBgUxZ5LsX/JT4Nn40xT8lUDukTNtEss8uNtJazhl/
         k9nlmYDD/z2v7Z5g2A/gcSZY39UpRqO3ZZQUM+G4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.107.236]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MJCAc-1jmPZj1sDK-002oE8; Mon, 15
 Jun 2020 10:54:09 +0200
Subject: Re: [PATCH v3 2/2] perf tools: Fix potential memory leaks in perf
 events parser
To:     Chen Wandun <chenwandun@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200615013614.8646-1-chenwandun@huawei.com>
 <20200615013614.8646-3-chenwandun@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f33f13bd-d337-bcb0-5aca-4b7900be9909@web.de>
Date:   Mon, 15 Jun 2020 10:54:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615013614.8646-3-chenwandun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:4W0dlm3kcJa7QOo0V2Dwx2C5qa0VPLn3YC2AfQkVkY3sdH6Efoi
 dYmRLng9APZhTry/m1YuZXehYaGNjBpSdrQ804HsXz419fD/L3vCWmEQ7YZkumO7JnUnT+Y
 KmEUvfyg8ykM9lS7LpPIbMZ6zbE5FlxZx5e0vo9SHjTVL25XDw3tmYfgZg6lB0JVnPvDCfW
 r4Hnot9yTia1jHMj9Rg3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:T9AwP/HRY4A=:0HOarJHIKjXFsZwOTz2qkE
 BHhML7i/2erQ/Gj7NODZhAhRMpkfM4YUEWuJuAD5zUPUZ+WClfIR00Aj3KPKyFSbwOCzAqem0
 BQyucPIlDUfVaAE6eGngv5M3Y6Ed9ZRXC1Jp1aBLwFgkBe+LMBTJBtQpSGcS1pzQ1KLqIU/0h
 VtAQBhNLoMgBprFKZHCbRV+nRV3WfoZ1aVFUTy0TWUs34lQA0Aq+TAQ5XpxcW6+JQ/oD0aeTy
 YozMHxLhq8ziJNmt5Hz9EHQIl5L8xsurZYFgOhJwIhhslBs5uXwLAjoq+writpufvQqg0FPBd
 NtBY+uUTAgBDNnWz5Yn5/hMvxbrEbtWMk8jv1ZLaJY4eC08weGcjtxXswa5gJ/D+oNF0z57Dq
 n0OKSYHYSFd19Hl7C6NeRb5AdKjYQtF3avIfPrHIhCj/r6HSxcCQ2opMp27uK+pCJTH/zjG3F
 2AvR3dPFTlD5PL6QiRHzee1OA1ve04hdI8jr0blP4IZ5P20bfdsdur4h80BRqXCQq1tS78h9E
 olrhubuRtIGoymZEgjC5oZd+HFEcUDdyvb1cy6RVqqzfkJUVh+Svif3Ti+WnVBHxxAnV7whDe
 9S62D9erlAPOiWOkMF4dX54G8rwpBrRGcQJZajF6d26gmysz3PKXjKdn3XtkOxZThEmMaC/4z
 OtDD6sWwPWFXsOsbPmls1qzB2E3zEAmkdpWMoC5ZLCXi/uanAeEYKHH5Pvd7V8N8Boruptj7C
 rQ1P3/mHu8zBrZze65NAo4X1Za2A0xxd0IjOFH+9KLqBT02G9v5kJ4o9wJmyUbgDPWayrfnI6
 Gaunm/nhXnZ3a+a9vYAnAJ9JfCCcg+0xSutfovQz8Ut1mWtWCF9IfK+bwKKlK4CK8jVZaiG1T
 RIZMKvwzGHcpnLfW/UoTb+73FMGR2odf+YUWoa4eZ4/9NCq4db1pH8pg3NW2REKezFos2oQCn
 I3Bxd8gPmnJcuEvhFqySkAW6tlx+SX90qEfhjiWaxJ7IQo6qh3yq0WyZEtP/6i0BWfmXx0JOd
 Ejc5J1PmchS/tkIfPVl5uV0JZ/jkoO6myklOFBC8BE1gWpyBSztymju7J/l2tUEzRt+BUO6z/
 ePes0jyNjM8LtwcbVbQs4haNB5famFjyJUmYJ8qGnGqO3pPv3/MFtsK9xuDEdZiQqpYu1IH4Q
 EQun6AWt2z9zyTsB/7vByI+Pshra72lOkdGKEQ0bsnMcjEF6rtIDzK9j0wDcnxphFSzJ/VQ/m
 jKH2fQhZ+kLHieIZT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix potential memory leak. Function new_term may return error, so
> it is need to free memory when the return value is negative.

I hope that a typo will be avoided for the final commit message.
Would you find any other description variant more pleasing?

Regards,
Markus
