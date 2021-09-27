Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9673419E45
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhI0SaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbhI0SaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:30:14 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D8C061575;
        Mon, 27 Sep 2021 11:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=TmarJA7lbERmnewe2c2OKyVYMSLgCnoqWSazUl7xW40=; b=RcGH3aVCtqkYIZecRUsTNi286u
        uHqaM7R8K1h85iUU3FzztJsB52D2rJCaRdRnFou9HHoT32/yHVVU2uMva4AxUn2+j4RXpR5WR1r9o
        D+dUcYR8Lbp+YCQEPP8sM4Z8KADvQ0EfE8YDLiDB//bzf+EoyXhx03KXg5DiXsooG0g9hbPRZpjt2
        HGnHQq0aVbIeW/qFb3C7XuRblb+DkkRWGsl7B28OIKQwvtuHqEHophBSxUeoO9RO/cwJqY2eSd+u6
        paG3pLgTOueck8uzkTHw3/wskrUj87TmrLrqTsHpXKJEj9CCFwHMT/xin8eUpUps0AtGB700t822Q
        /GezAWvw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUvMe-003mf5-Sp; Mon, 27 Sep 2021 18:28:32 +0000
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com
Cc:     yannick.vignon@oss.nxp.com, rui.sousa@oss.nxp.com
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6a08ba71-02c7-638c-3a8a-b5d56a32111b@infradead.org>
Date:   Mon, 27 Sep 2021 11:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 2:32 AM, Sebastien Laveze wrote:
> From: Seb Laveze <sebastien.laveze@nxp.com>
> 
> Add an IOCTL to perform per-timestamp conversion, as an extension of the
> ptp virtual framework introduced in commit 5d43f951b1ac ("ptp: add ptp
> virtual clock driver framework").
> 
> The original implementation allows binding a socket to a given virtual
> clock to perform the timestamps conversions. Commit 5d43f951b1ac ("ptp:
> add ptp virtual clock driver framework").
> 
> This binding works well if the application requires all timestamps in the
> same domain but is not convenient when multiple domains need to be
> supported using a single socket.
> 
> Typically, IEEE 802.1AS-2020 can be implemented using a single socket,
> the CMLDS layer using raw PHC timestamps and the domain specific
> timestamps converted in the appropriate gPTP domain using this IOCTL.
> 
> Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
> ---
>   drivers/ptp/ptp_chardev.c      | 24 ++++++++++++++++++++++++
>   include/uapi/linux/ptp_clock.h |  1 +
>   2 files changed, 25 insertions(+)
> 

> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 1d108d597f66..13147d454aa8 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -223,6 +223,7 @@ struct ptp_pin_desc {
>   	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
>   #define PTP_SYS_OFFSET_EXTENDED2 \
>   	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
> +#define PTP_VCLOCK_CONV_TS  _IOWR(PTP_CLK_MAGIC, 19, struct __kernel_timespec)
>   
>   struct ptp_extts_event {
>   	struct ptp_clock_time t; /* Time event occured. */
> 

Hi,
Would someone please update Documentation/userspace-api/ioctl/ioctl-number.rst
to include
#define PTP_CLK_MAGIC '=', the name of this header file, and optional
comment or contact info, please.

thanks.
-- 
~Randy
