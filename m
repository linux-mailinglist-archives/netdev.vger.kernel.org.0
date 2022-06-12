Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590BD547CD8
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 00:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiFLWrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 18:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiFLWrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 18:47:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1007A15FD2;
        Sun, 12 Jun 2022 15:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA60B801BD;
        Sun, 12 Jun 2022 22:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0503C34115;
        Sun, 12 Jun 2022 22:47:02 +0000 (UTC)
Date:   Sun, 12 Jun 2022 18:46:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 05/06] 9p fid refcount: add a 9p_fid_ref tracepoint
Message-ID: <20220612184659.6dff5107@rorschach.local.home>
In-Reply-To: <20220612085330.1451496-6-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
        <20220612085330.1451496-6-asmadeus@codewreck.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jun 2022 17:53:28 +0900
Dominique Martinet <asmadeus@codewreck.org> wrote:

This needs to have a change log. A tracepoint should never be added
without explaining why it is being added and its purpose.

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
> 
> This is the first time I add a tracepoint, so if anyone has time to
> check I didn't make something too stupid please have a look.
> I've mostly copied from netfs'.
> 
> Also, a question if someone has time: I'd have liked to use the
> tracepoint in static inline wrappers for getref/putref, but it's not
> good to add the tracepoints to a .h, right?

Correct, because it can have unexpected side effects. Thus it is best
to call a wrapper function that is defined in a C file that will then
call the tracepoint. To avoid the overhead of the function call when
tracing is not enabled, you should use (in the header):

  #include <linux/tracepoint-defs.h>

  DECLARE_TRACEPOINT(<tracepoint-name>);

  if (tracepoint_enabled(<tracepoint-name>))
	do_<tracepoint-name>(...);

and in the C file have:

  void do_<tracepoint-name>(...)
  {
	trace_<tracepoint-name>(...);
  }

that calls the tracepoint. The tracepoint_enabled(<tracepoint-name>)()
is another special function that is created by the TRACE_EVENT() macro
to use, that is a static branch and not a real if statement. That is, it
is a nop that skips calling the wrapper function when not enabled, and
a jmp to call the wrapper function when the tracepoint is enabled.

How to do this is described in include/linux/tracepoint-defs.h and
there's an example of this use case in include/linux/mmap_lock.h.

> Especially with the CREATE_TRACE_POINTS macro...
> How do people usually go about that, just bite the bullet and make it
> a real function?
> 
> 
>  include/trace/events/9p.h | 48 +++++++++++++++++++++++++++++++++++++++
>  net/9p/client.c           |  9 +++++++-
>  2 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
> index 78c5608a1648..4dfa6d7f83ba 100644
> --- a/include/trace/events/9p.h
> +++ b/include/trace/events/9p.h
> @@ -77,6 +77,13 @@
>  		EM( P9_TWSTAT,		"P9_TWSTAT" )			\
>  		EMe(P9_RWSTAT,		"P9_RWSTAT" )
>  
> +
> +#define P9_FID_REFTYPE							\
> +		EM( P9_FID_REF_CREATE,	"create " )			\
> +		EM( P9_FID_REF_GET,	"get    " )			\
> +		EM( P9_FID_REF_PUT,	"put    " )			\
> +		EMe(P9_FID_REF_DESTROY,	"destroy" )
> +
>  /* Define EM() to export the enums to userspace via TRACE_DEFINE_ENUM() */
>  #undef EM
>  #undef EMe
> @@ -84,6 +91,21 @@
>  #define EMe(a, b)	TRACE_DEFINE_ENUM(a);
>  
>  P9_MSG_T
> +P9_FID_REFTYPE
> +
> +/* And also use EM/EMe to define helper enums -- once */
> +#ifndef __9P_DECLARE_TRACE_ENUMS_ONLY_ONCE
> +#define __9P_DECLARE_TRACE_ENUMS_ONLY_ONCE
> +#undef EM
> +#undef EMe
> +#define EM(a, b)	a,
> +#define EMe(a, b)	a
> +
> +enum p9_fid_reftype {
> +	P9_FID_REFTYPE
> +} __mode(byte);
> +
> +#endif
>  
>  /*
>   * Now redefine the EM() and EMe() macros to map the enums to the strings
> @@ -96,6 +118,8 @@ P9_MSG_T
>  
>  #define show_9p_op(type)						\
>  	__print_symbolic(type, P9_MSG_T)
> +#define show_9p_fid_reftype(type)					\
> +	__print_symbolic(type, P9_FID_REFTYPE)
>  
>  TRACE_EVENT(9p_client_req,
>  	    TP_PROTO(struct p9_client *clnt, int8_t type, int tag),
> @@ -168,6 +192,30 @@ TRACE_EVENT(9p_protocol_dump,
>  		      __entry->tag, 0, __entry->line, 16, __entry->line + 16)
>   );
>  
> +
> +TRACE_EVENT(9p_fid_ref,
> +	    TP_PROTO(struct p9_fid *fid, __u8 type),
> +
> +	    TP_ARGS(fid, type),
> +
> +	    TP_STRUCT__entry(
> +		    __field(	int,	fid		)
> +		    __field(	int,	refcount	)
> +		    __field(	__u8, type	)
> +		    ),
> +
> +	    TP_fast_assign(
> +		    __entry->fid = fid->fid;
> +		    __entry->refcount = refcount_read(&fid->count);
> +		    __entry->type = type;
> +		    ),
> +
> +	    TP_printk("%s fid %d, refcount %d",
> +		      show_9p_fid_reftype(__entry->type),
> +		      __entry->fid, __entry->refcount)
> +);
> +
> +
>  #endif /* _TRACE_9P_H */
>  
>  /* This part must be outside protection */
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 5531b31e0fb2..fdeeda0a811d 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -907,8 +907,10 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
>  			    GFP_NOWAIT);
>  	spin_unlock_irq(&clnt->lock);
>  	idr_preload_end();
> -	if (!ret)
> +	if (!ret) {
> +		trace_9p_fid_ref(fid, P9_FID_REF_CREATE);
>  		return fid;
> +	}
>  
>  	kfree(fid);
>  	return NULL;
> @@ -920,6 +922,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
>  	unsigned long flags;
>  
>  	p9_debug(P9_DEBUG_FID, "fid %d\n", fid->fid);
> +	trace_9p_fid_ref(fid, P9_FID_REF_DESTROY);
>  	clnt = fid->clnt;
>  	spin_lock_irqsave(&clnt->lock, flags);
>  	idr_remove(&clnt->fids, fid->fid);
> @@ -932,6 +935,8 @@ static void p9_fid_destroy(struct p9_fid *fid)
>   * because trace_* functions can't be used there easily
>   */
>  struct p9_fid *p9_fid_get(struct p9_fid *fid) {
> +	trace_9p_fid_ref(fid, P9_FID_REF_GET);
> +
>  	refcount_inc(&fid->count);
>  
>  	return fid;
> @@ -941,6 +946,8 @@ int p9_fid_put(struct p9_fid *fid) {
>  	if (!fid || IS_ERR(fid))
>  		return 0;
>  
> +	trace_9p_fid_ref(fid, P9_FID_REF_PUT);
> +
>          if (!refcount_dec_and_test(&fid->count))
>                  return 0;
>  

Nothing stands out to me that would be wrong with the above.

-- Steve

