Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894803BA743
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 06:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhGCEwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 00:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGCEwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 00:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D3EA613C9;
        Sat,  3 Jul 2021 04:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625287788;
        bh=mGZyq3JSQsP4iGY+awgr6y4sM3v63gkuGZxGC42AQJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qrxe9zLtWfzjmDX9BHre42DOiJuHuM8V5xGwohED6e4CSZ4K38p9MJQTvcYGjI8xM
         jjQwyVhvc+UfyH/3tgj0L7urGLB/lTsYjDjozqus5pLbOH67LBRr4aFig8yekeG3tN
         u5XWPLwsOrr8kSRTc1SXwzg9ImErPRTOm9W614To=
Date:   Sat, 3 Jul 2021 06:49:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] test_sysfs: demonstrate deadlock fix
Message-ID: <YN/sar6nGeSCn89/@kroah.com>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703004632.621662-5-mcgrof@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 05:46:32PM -0700, Luis Chamberlain wrote:
> +#define MODULE_DEVICE_ATTR_FUNC_STORE(_name) \
> +static ssize_t module_ ## _name ## _store(struct device *dev, \
> +				   struct device_attribute *attr, \
> +				   const char *buf, size_t len) \
> +{ \
> +	ssize_t __ret; \
> +	if (!try_module_get(THIS_MODULE)) \
> +		return -ENODEV; \
> +	__ret = _name ## _store(dev, attr, buf, len); \
> +	module_put(THIS_MODULE); \
> +	return __ret; \
> +}

As I have pointed out before, doing try_module_get(THIS_MODULE) is racy
and should not be added back to the kernel tree.  We got rid of many
instances of this "bad pattern" over the years, please do not encourage
it to be added back as others will somehow think that it correct code.

I'll go over the rest of this after 5.14-rc1 is out, am busy until then.

thanks,

greg k-h
