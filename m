Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302611CC25A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgEIPSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 11:18:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727105AbgEIPSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 11:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589037529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2hue1lsqi4XMQF5NNNjmHFzI6rV7rqILxUYM7fa3fzw=;
        b=YJ2d8EYD4FVilA27YJAQh6Qx8P1toj7L5S1er+qPtC9LQmXJ2mOoqAyrJX1VN7pGJumy0B
        19U/6PBRFR4vSiTkTEmYI/Lb5v3yqVwEWvnIMn6rEGNmGEHt963bVaMcJ3FwFyXGlmvQJM
        NyEJGVmz0d8b2A/Cj7ucQoWTazOUsF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-ibVo1IHvNMusTg053bOBew-1; Sat, 09 May 2020 11:18:45 -0400
X-MC-Unique: ibVo1IHvNMusTg053bOBew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C41331005510;
        Sat,  9 May 2020 15:18:41 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E88F1001925;
        Sat,  9 May 2020 15:18:31 +0000 (UTC)
Date:   Sat, 9 May 2020 11:18:29 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, cai@lca.pw,
        dyoung@redhat.com, bhe@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, gpiccoli@canonical.com, pmladek@suse.com,
        tiwai@suse.de, schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] taint: add module firmware crash taint support
Message-ID: <20200509151829.GB6704@x1-fbsd>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509043552.8745-2-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 04:35:38AM +0000, Luis Chamberlain wrote:
> Device driver firmware can crash, and sometimes, this can leave your
> system in a state which makes the device or subsystem completely
> useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> of scraping some magical words from the kernel log, which is driver
> specific, is much easier. So instead provide a helper which lets drivers
> annotate this.
> 
> Once this happens, scrapers can easily look for modules taint flags
> for a firmware crash. This will taint both the kernel and respective
> calling module.
> 
> The new helper module_firmware_crashed() uses LOCKDEP_STILL_OK as this
> fact should in no way shape or form affect lockdep. This taint is device
> driver specific.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  include/linux/kernel.h        |  3 ++-
>  include/linux/module.h        | 13 +++++++++++++
>  include/trace/events/module.h |  3 ++-
>  kernel/module.c               |  5 +++--
>  kernel/panic.c                |  1 +
>  5 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 04a5885cec1b..19e1541c82c7 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -601,7 +601,8 @@ extern enum system_states {
>  #define TAINT_LIVEPATCH			15
>  #define TAINT_AUX			16
>  #define TAINT_RANDSTRUCT		17
> -#define TAINT_FLAGS_COUNT		18
> +#define TAINT_FIRMWARE_CRASH		18
> +#define TAINT_FLAGS_COUNT		19
>

We are still missing the documentation bits for this
new flag, though.

How about having a blurb similar to:

diff --git a/Documentation/admin-guide/tainted-kernels.rst b/Documentation/admin-guide/tainted-kernels.rst
index 71e9184a9079..5c6a9e2478b0 100644
--- a/Documentation/admin-guide/tainted-kernels.rst
+++ b/Documentation/admin-guide/tainted-kernels.rst
@@ -100,6 +100,7 @@ Bit  Log  Number  Reason that got the kernel tainted
  15  _/K   32768  kernel has been live patched
  16  _/X   65536  auxiliary taint, defined for and used by distros
  17  _/T  131072  kernel was built with the struct randomization plugin
+ 18  _/Q  262144  driver firmware crash annotation
 ===  ===  ======  ========================================================

 Note: The character ``_`` is representing a blank in this table to make reading
@@ -162,3 +163,7 @@ More detailed explanation for tainting
      produce extremely unusual kernel structure layouts (even performance
      pathological ones), which is important to know when debugging. Set at
      build time.
+
+ 18) ``Q`` Device drivers might annotate the kernel with this taint, in cases
+     their firmware might have crashed leaving the driver in a crippled and
+     potentially useless state.




>  struct taint_flag {
>  	char c_true;	/* character printed when tainted */
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 2c2e988bcf10..221200078180 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -697,6 +697,14 @@ static inline bool is_livepatch_module(struct module *mod)
>  bool is_module_sig_enforced(void);
>  void set_module_sig_enforced(void);
>  
> +void add_taint_module(struct module *mod, unsigned flag,
> +		      enum lockdep_ok lockdep_ok);
> +
> +static inline void module_firmware_crashed(void)
> +{
> +	add_taint_module(THIS_MODULE, TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
> +}
> +
>  #else /* !CONFIG_MODULES... */
>  
>  static inline struct module *__module_address(unsigned long addr)
> @@ -844,6 +852,11 @@ void *dereference_module_function_descriptor(struct module *mod, void *ptr)
>  	return ptr;
>  }
>  
> +static inline void module_firmware_crashed(void)
> +{
> +	add_taint(TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
> +}
> +
>  #endif /* CONFIG_MODULES */
>  
>  #ifdef CONFIG_SYSFS
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index 097485c73c01..b749ea25affd 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -26,7 +26,8 @@ struct module;
>  	{ (1UL << TAINT_OOT_MODULE),		"O" },		\
>  	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
>  	{ (1UL << TAINT_CRAP),			"C" },		\
> -	{ (1UL << TAINT_UNSIGNED_MODULE),	"E" })
> +	{ (1UL << TAINT_UNSIGNED_MODULE),	"E" },		\
> +	{ (1UL << TAINT_FIRMWARE_CRASH),	"Q" })
>  
>  TRACE_EVENT(module_load,
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index 80faaf2116dd..f98e8c25c6b4 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -325,12 +325,13 @@ static inline int strong_try_module_get(struct module *mod)
>  		return -ENOENT;
>  }
>  
> -static inline void add_taint_module(struct module *mod, unsigned flag,
> -				    enum lockdep_ok lockdep_ok)
> +void add_taint_module(struct module *mod, unsigned flag,
> +		      enum lockdep_ok lockdep_ok)
>  {
>  	add_taint(flag, lockdep_ok);
>  	set_bit(flag, &mod->taints);
>  }
> +EXPORT_SYMBOL_GPL(add_taint_module);
>  
>  /*
>   * A thread that wants to hold a reference to a module only while it
> diff --git a/kernel/panic.c b/kernel/panic.c
> index ec6d7d788ce7..504fb926947e 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -384,6 +384,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
>  	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
>  	[ TAINT_AUX ]			= { 'X', ' ', true },
>  	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
> +	[ TAINT_FIRMWARE_CRASH ]	= { 'Q', ' ', true },
>  };
>  
>  /**
> -- 
> 2.25.1
> 

