Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F39CBBA0
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388517AbfJDNYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387952AbfJDNYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:24:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A9DF305FC56;
        Fri,  4 Oct 2019 13:24:18 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CCA319C68;
        Fri,  4 Oct 2019 13:24:11 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:24:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v4 2/4] samples: pktgen: fix proc_cmd command result check
 logic
Message-ID: <20191004152409.55bb1ae0@carbon>
In-Reply-To: <20191004013301.8686-2-danieltimlee@gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com>
        <20191004013301.8686-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 04 Oct 2019 13:24:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Oct 2019 10:32:59 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> Currently, proc_cmd is used to dispatch command to 'pg_ctrl', 'pg_thread',
> 'pg_set'. proc_cmd is designed to check command result with grep the
> "Result:", but this might fail since this string is only shown in
> 'pg_thread' and 'pg_set'.
> 
> This commit fixes this logic by grep-ing the "Result:" string only when
> the command is not for 'pg_ctrl'.
> 
> For clarity of an execution flow, 'errexit' flag has been set.
> 
> To cleanup pktgen on exit, trap has been added for EXIT signal.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/pktgen/functions.sh | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index 4af4046d71be..e1865660b033 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -5,6 +5,8 @@
>  # Author: Jesper Dangaaard Brouer
>  # License: GPL
>  
> +set -o errexit
> +
>  ## -- General shell logging cmds --
>  function err() {
>      local exitcode=$1
> @@ -58,6 +60,7 @@ function pg_set() {
>  function proc_cmd() {
>      local result
>      local proc_file=$1
> +    local status=0
>      # after shift, the remaining args are contained in $@
>      shift
>      local proc_ctrl=${PROC_DIR}/$proc_file
> @@ -73,13 +76,14 @@ function proc_cmd() {
>  	echo "cmd: $@ > $proc_ctrl"
>      fi
>      # Quoting of "$@" is important for space expansion
> -    echo "$@" > "$proc_ctrl"
> -    local status=$?
> -
> -    result=$(grep "Result: OK:" $proc_ctrl)
> -    # Due to pgctrl, cannot use exit code $? from grep
> -    if [[ "$result" == "" ]]; then
> -	grep "Result:" $proc_ctrl >&2
> +    echo "$@" > "$proc_ctrl" || status=$?
> +
> +    if [[ "$proc_file" != "pgctrl" ]]; then
> +        result=$(grep "Result: OK:" $proc_ctrl) || true
> +        # Due to pgctrl, cannot use exit code $? from grep

Is this comment still relevant?  You just excluded "pgctrl" from
getting into this section.

> +        if [[ "$result" == "" ]]; then
> +        grep "Result:" $proc_ctrl >&2

Missing tap/indention?

> +        fi
>      fi
>      if (( $status != 0 )); then
>  	err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
> @@ -105,6 +109,8 @@ function pgset() {
>      fi
>  }
>  
> +trap 'pg_ctrl "reset"' EXIT
> +

This line is activated when I ctrl-C the scripts, but something weird
happens, it reports:

 ERROR: proc file:/proc/net/pktgen/pgctrl not writable, not root?!


>  ## -- General shell tricks --
>  
>  function root_check_run_with_sudo() {



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
