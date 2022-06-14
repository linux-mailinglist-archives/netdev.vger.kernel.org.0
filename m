Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B64A54B431
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 17:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbiFNPH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 11:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbiFNPH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 11:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C4927FDA
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 08:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9741860C88
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD802C3411B;
        Tue, 14 Jun 2022 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655219276;
        bh=mYMpK722PoNUYcM7o9muc9ZO7YQi6gnPYUPorox/IpA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=qI90cnUQ8atPL21jZ2Q2dmOSFO4EGdgkYgPiLnJ7mDilG9HyRKBxcvFCSMc+XUT+m
         zwB+Iz34GW4BWQe1AuPVZ6WX+lXD7wI1MSSuEKFtvHuiG0ZoY9Y877iG7pDIEkXKAP
         K0U41l+I31wIa/60X8ZPfp+IyiWzo757ak5y9jHg67SDFNdXoNnjNdE7uRBP2jvDZv
         yl4jFocjeVQjaZRhHMVnbf2jdEsoEJaR0H6urG5bqPu+orLh/JE75qPRx1oAbX6qCu
         J6AlwmLvmF6fla8Zd/+21ezSVZKxblvLbFS7VJ+W81DIM1NCLMVDv0T7TN9nQnyTNS
         AgAGZPaTwC0rw==
Message-ID: <55939b65-7a91-84d1-b851-0d30d9938283@kernel.org>
Date:   Tue, 14 Jun 2022 09:07:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] vdpa: Add support for reading vdpa device statistics
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, jasowang@redhat.com,
        si-wei.liu@oracle.com, mst@redhat.com
References: <20220601121021.487664-1-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220601121021.487664-1-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/22 6:10 AM, Eli Cohen wrote:
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 3ae1b78f4cac..3ca3095ed783 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -304,6 +320,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>  
>  			NEXT_ARG_FWD();
>  			o_found |= VDPA_OPT_MAX_VQP;
> +		} else if ((matches(*argv, "qidx")  == 0) && (o_optional & VDPA_OPT_QUEUE_INDEX)) {

above line should be wrapped.

Also, please convert all new matches() to strcmp; we are not taking any
new users of matches() api.

> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u32(vdpa, argc, argv, &opts->queue_idx);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_QUEUE_INDEX;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;
> @@ -594,6 +618,7 @@ static void cmd_dev_help(void)
>  	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
>  	fprintf(stderr, "       vdpa dev del DEV\n");
>  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> +	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>  }
>  
>  static const char *device_type_name(uint32_t type)
> @@ -819,6 +844,135 @@ static int cmd_dev_config(struct vdpa *vdpa, int argc, char **argv)
>  	return -ENOENT;
>  }
>  
> +#define MAX_KEY_LEN 200
> +/* 5 bytes for format */
> +#define MAX_FMT_LEN (MAX_KEY_LEN + 5 + 1)
> +
> +static void pr_out_dev_net_vstats(const struct nlmsghdr *nlh)
> +{
> +	const char *name = NULL;
> +	uint64_t features = 0;
> +	char fmt[MAX_FMT_LEN];
> +	uint16_t max_vqp = 0;
> +	bool is_ctrl = false;
> +	struct nlattr *attr;
> +	uint16_t qidx = 0;
> +	uint64_t v64;
> +
> +	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
> +		switch (attr->nla_type) {
> +		case VDPA_ATTR_DEV_NET_CFG_MAX_VQP:
> +			max_vqp = mnl_attr_get_u16(attr);
> +			break;
> +		case VDPA_ATTR_DEV_NEGOTIATED_FEATURES:
> +			features = mnl_attr_get_u64(attr);
> +			break;
> +		case VDPA_ATTR_DEV_QUEUE_INDEX:
> +			qidx = mnl_attr_get_u16(attr);
> +			is_ctrl = features & BIT(VIRTIO_NET_F_CTRL_VQ) && qidx == 2 * max_vqp;
> +			if (!is_ctrl) {
> +				if (qidx & 1)
> +					print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +						     "tx");
> +				else
> +					print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +						     "rx");
> +			} else {
> +				print_string(PRINT_ANY, "queue_type", "queue_type %s ",
> +					     "control_vq");
> +			}

the above should be in a helper function to keep line lengths at a
reasonable size.


