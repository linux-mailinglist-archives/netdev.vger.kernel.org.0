Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1637920A0A9
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405285AbgFYOOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:14:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405360AbgFYOOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 10:14:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joSdb-002DD5-6Z; Thu, 25 Jun 2020 16:13:59 +0200
Date:   Thu, 25 Jun 2020 16:13:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v2 4/6] Add --json command line argument parsing
Message-ID: <20200625141359.GL442307@lunn.ch>
References: <20200625001244.503790-1-andrew@lunn.ch>
 <20200625001244.503790-5-andrew@lunn.ch>
 <20200624223258.140f6cad@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624223258.140f6cad@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 10:32:58PM -0700, Stephen Hemminger wrote:
> On Thu, 25 Jun 2020 02:12:42 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > diff --git a/internal.h b/internal.h
> > index edb07bd..7135140 100644
> > --- a/internal.h
> > +++ b/internal.h
> > @@ -23,6 +23,8 @@
> >  #include <sys/ioctl.h>
> >  #include <net/if.h>
> >  
> > +#include "json_writer.h"
> > +
> >  #define maybe_unused __attribute__((__unused__))
> >  
> >  /* internal for netlink interface */
> > @@ -221,6 +223,8 @@ struct cmd_context {
> >  	int argc;		/* number of arguments to the sub-command */
> >  	char **argp;		/* arguments to the sub-command */
> >  	unsigned long debug;	/* debugging mask */
> > +	bool json;		/* Output JSON, if supported */
> > +	json_writer_t *jw;      /* JSON writer instance */
> 
> You can avoid the boolean by just checking for NULL jw variable.

Hi Stephen

It is a while since i wrote this code, but i think i considered
that. The problem is, only a few commands support json output. I could
call json_new() unconditional of if the command actually support json
or not, that is not a problem. But then json_destory() should also be
unconditionally called. And that does fputs("\n", self->out); So you
end up with an extra blank line.

Using the boolean allows me to defer json_new()/json_destroy() into
the actual commands which supports json.

       Andrew
