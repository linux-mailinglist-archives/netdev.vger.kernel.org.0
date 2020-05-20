Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE51DB7B5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgETPHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETPHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:07:53 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A08D2054F;
        Wed, 20 May 2020 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589987272;
        bh=8VBA9kFdjdfRlKPEK46ZtWpmUq8WEwLqJ2P0szY8vsc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=voKh9N8h0YWJaND3rq5MWEC8Rwr72Xt5vuNq4vxv3cM7Rz1qfbpYifGnlVTc3C3NH
         MzFn2Gm9/+GWRTFQAtI9aWJ3zn3CV3ZGdBlFlx3SOhGxKiDn1SK/zmDBpIgGtlYTZK
         HB+enmZ/sw8Bh5MCBehK5tFyI5XLFC7AIqKhiD0o=
Message-ID: <ed3d0ebdeabe53c6cfc0c6fd185dc50f4055a0e6.camel@kernel.org>
Subject: Re: [PATCH] dns: Apply a default TTL to records obtained from
 getaddrinfo()
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>, me@benboeckel.net,
        fweimer@redhat.com
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 20 May 2020 11:07:50 -0400
In-Reply-To: <1512927.1589904409@warthog.procyon.org.uk>
References: <20200519141432.GA2949457@erythro.dev.benboeckel.internal>
         <20200518155148.GA2595638@erythro.dev.benboeckel.internal>
         <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
         <1080378.1589895580@warthog.procyon.org.uk>
         <1512927.1589904409@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-05-19 at 17:06 +0100, David Howells wrote:
> Okay, how about this incremental change, then?  If fixes the typo, only prints
> the "READ CONFIG" line in verbose mode, filters escape chars in the config
> file and reduces the expiration time to 5s.
> 
> David
> ---
> diff --git a/key.dns_resolver.c b/key.dns_resolver.c
> index c241eda3..7a7ec424 100644
> --- a/key.dns_resolver.c
> +++ b/key.dns_resolver.c
> @@ -52,7 +52,7 @@ key_serial_t key;
>  static int verbose;
>  int debug_mode;
>  unsigned mask = INET_ALL;
> -unsigned int key_expiry = 10 * 60;
> +unsigned int key_expiry = 5;
>  
>  
>  /*
> @@ -109,7 +109,7 @@ void _error(const char *fmt, ...)
>  }
>  
>  /*
> - * Pring a warning to stderr or the syslog
> + * Print a warning to stderr or the syslog
>   */
>  void warning(const char *fmt, ...)
>  {
> @@ -454,7 +454,7 @@ static void read_config(void)
>  	unsigned int line = 0, u;
>  	int n;
>  
> -	printf("READ CONFIG %s\n", config_file);
> +	info("READ CONFIG %s", config_file);
>  
>  	f = fopen(config_file, "r");
>  	if (!f) {
> @@ -514,6 +514,16 @@ static void read_config(void)
>  			v = p = b;
>  			while (*b) {
>  				if (esc) {
> +					switch (*b) {
> +					case ' ':
> +					case '\t':
> +					case '"':
> +					case '\'':
> +					case '\\':
> +						break;
> +					default:
> +						goto invalid_escape_char;
> +					}
>  					esc = false;
>  					*p++ = *b++;
>  					continue;
> @@ -563,6 +573,8 @@ static void read_config(void)
>  
>  missing_value:
>  	error("%s:%u: %s: Missing value", config_file, line, k);
> +invalid_escape_char:
> +	error("%s:%u: %s: Invalid char in escape", config_file, line, k);
>  post_quote_data:
>  	error("%s:%u: %s: Data after closing quote", config_file, line, k);
>  bad_value:
> diff --git a/man/key.dns_resolver.conf.5 b/man/key.dns_resolver.conf.5
> index 03d04049..c944ad55 100644
> --- a/man/key.dns_resolver.conf.5
> +++ b/man/key.dns_resolver.conf.5
> @@ -34,7 +34,7 @@ Available options include:
>  The number of seconds to set as the expiration on a cached record.  This will
>  be overridden if the program manages to retrieve TTL information along with
>  the addresses (if, for example, it accesses the DNS directly).  The default is
> -600 seconds.  The value must be in the range 1 to INT_MAX.
> +5 seconds.  The value must be in the range 1 to INT_MAX.
>  .P
>  The file can also include comments beginning with a '#' character unless
>  otherwise suppressed by being inside a quoted value or being escaped with a
> 

This looks good to me.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

