Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84A11B51B8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDWBRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:17:11 -0400
Received: from mail.hallyn.com ([178.63.66.53]:52630 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDWBRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 21:17:11 -0400
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 68CE37D3; Wed, 22 Apr 2020 20:17:06 -0500 (CDT)
Date:   Wed, 22 Apr 2020 20:17:06 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: Re: [PATCH v2 5/7] loop: preserve sysfs backwards compatibility
Message-ID: <20200423011706.GA2982@mail.hallyn.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-6-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422145437.176057-6-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:54:35PM +0200, Christian Brauner wrote:
> For sysfs the initial namespace is special. All devices currently
> propagate into all non-initial namespaces. For example, sysfs is usually
> mounted in a privileged or unprivileged container and all devices are
> visible to the container but are owned by global root. Even though none
> of the propagated files can be used there are still a lot of read-only
> values that are accessed or read by tools running in non-initial
> namespaces. Some devices though, which can be moved or created in
> another namespace, will only show up in the corresponding namespace.
> This currently includes network and loop devices but no other ones.
> Since all current workloads depend on devices from the inital namespace
> being visible this behavior cannot be simply changed. This patch just
> makes sure to keep propagating devices that share the same device class
> with loop devices from the initial namespaces into all non-initial
> namespaces as before. In short, nothing changes only loopfs loop devices
> will be shown in their correct namespace.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Hi,

two comments below:

> ---
> /* v2 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Protect init_net with a CONFIG_NET ifdef in case it is set to "n".
>   - As Tejun pointed out there is argument to be made that a new mount
>     option for sysfs could be added that would change how devices are
>     propagated. This patch does not prevent this but it is an orthogonal
>     problem.
> ---
>  block/genhd.c               | 79 +++++++++++++++++++++++++++++++++++++
>  fs/kernfs/dir.c             | 34 +++++++++++++---
>  fs/kernfs/kernfs-internal.h | 24 +++++++++++
>  fs/sysfs/mount.c            |  4 ++
>  include/linux/genhd.h       |  3 ++
>  include/linux/kernfs.h      | 22 +++++++++++
>  include/linux/kobject_ns.h  |  4 ++
>  lib/kobject.c               |  2 +
>  8 files changed, 167 insertions(+), 5 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 06b642b23a07..b5b2601c4311 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1198,11 +1198,81 @@ static struct kobject *base_probe(dev_t devt, int *partno, void *data)
>  	return NULL;
>  }
>  
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +static void *user_grab_current_ns(void)
> +{
> +	struct user_namespace *ns = current_user_ns();
> +	return get_user_ns(ns);
> +}
> +
> +static const void *user_initial_ns(void)
> +{
> +	return &init_user_ns;
> +}
> +
> +static void user_put_ns(void *p)
> +{
> +	struct user_namespace *ns = p;
> +	put_user_ns(ns);
> +}
> +
> +static bool user_current_may_mount(void)
> +{
> +	return ns_capable(current_user_ns(), CAP_SYS_ADMIN);
> +}
> +
> +const struct kobj_ns_type_operations user_ns_type_operations = {
> +	.type			= KOBJ_NS_TYPE_USER,
> +	.current_may_mount	= user_current_may_mount,
> +	.grab_current_ns	= user_grab_current_ns,
> +	.initial_ns		= user_initial_ns,
> +	.drop_ns		= user_put_ns,
> +};
> +
> +static const void *block_class_user_namespace(struct device *dev)
> +{
> +	struct gendisk *disk;
> +
> +	if (dev->type == &part_type)
> +		disk = part_to_disk(dev_to_part(dev));
> +	else
> +		disk = dev_to_disk(dev);
> +
> +	return disk->user_ns;
> +}
> +
> +static void block_class_get_ownership(struct device *dev, kuid_t *uid, kgid_t *gid)
> +{
> +	struct gendisk *disk;
> +	struct user_namespace *ns;
> +
> +	if (dev->type == &part_type)
> +		disk = part_to_disk(dev_to_part(dev));
> +	else
> +		disk = dev_to_disk(dev);
> +
> +	ns = disk->user_ns;
> +	if (ns && ns != &init_user_ns) {
> +		kuid_t ns_root_uid = make_kuid(ns, 0);
> +		kgid_t ns_root_gid = make_kgid(ns, 0);
> +
> +		if (uid_valid(ns_root_uid))
> +			*uid = ns_root_uid;
> +
> +		if (gid_valid(ns_root_gid))
> +			*gid = ns_root_gid;
> +	}

You're not setting uid and gid in the else case?

> +}
> +#endif /* CONFIG_BLK_DEV_LOOPFS */
> +
>  static int __init genhd_device_init(void)
>  {
>  	int error;
>  
>  	block_class.dev_kobj = sysfs_dev_block_kobj;
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +	kobj_ns_type_register(&user_ns_type_operations);
> +#endif
>  	error = class_register(&block_class);
>  	if (unlikely(error))
>  		return error;
> @@ -1524,8 +1594,14 @@ static void disk_release(struct device *dev)
>  		blk_put_queue(disk->queue);
>  	kfree(disk);
>  }
> +
>  struct class block_class = {
>  	.name		= "block",
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +	.ns_type	= &user_ns_type_operations,
> +	.namespace	= block_class_user_namespace,
> +	.get_ownership	= block_class_get_ownership,
> +#endif
>  };
>  
>  static char *block_devnode(struct device *dev, umode_t *mode,
> @@ -1715,6 +1791,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  		disk_to_dev(disk)->class = &block_class;
>  		disk_to_dev(disk)->type = &disk_type;
>  		device_initialize(disk_to_dev(disk));
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +		disk->user_ns = &init_user_ns;
> +#endif
>  	}
>  	return disk;
>  }
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 1f2d894ae454..02796ba6521a 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -575,10 +575,15 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
>  		goto out_bad;
>  
>  	/* The kernfs node has been moved to a different namespace */
> -	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
> -	    kernfs_info(dentry->d_sb)->ns[kn->ns_type] != kn->ns)
> -		goto out_bad;
> +	if (kn->parent && kernfs_ns_enabled(kn->parent)) {
> +		if (kernfs_init_ns_propagates(kn->parent) &&
> +		    kn->ns == kernfs_init_ns(kn->parent->ns_type))
> +			goto out_good;
> +		if (kernfs_info(dentry->d_sb)->ns[kn->parent->ns_type] != kn->ns)
> +			goto out_bad;
> +	}
>  
> +out_good:
>  	mutex_unlock(&kernfs_mutex);
>  	return 1;
>  out_bad:
> @@ -1090,6 +1095,10 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
>  		ns = kernfs_info(dir->i_sb)->ns[parent->ns_type];
>  
>  	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
> +	if (!kn && kernfs_init_ns_propagates(parent)) {
> +		ns = kernfs_init_ns(parent->ns_type);
> +		kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
> +	}
>  
>  	/* no such entry */
>  	if (!kn || !kernfs_active(kn)) {
> @@ -1614,6 +1623,8 @@ static int kernfs_dir_fop_release(struct inode *inode, struct file *filp)
>  static struct kernfs_node *kernfs_dir_pos(const void *ns,
>  	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
>  {
> +	const void *init_ns;
> +
>  	if (pos) {
>  		int valid = kernfs_active(pos) &&
>  			pos->parent == parent && hash == pos->hash;
> @@ -1621,6 +1632,12 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
>  		if (!valid)
>  			pos = NULL;
>  	}
> +
> +	if (kernfs_init_ns_propagates(parent))
> +		init_ns = kernfs_init_ns(parent->ns_type);
> +	else
> +		init_ns = NULL;
> +
>  	if (!pos && (hash > 1) && (hash < INT_MAX)) {
>  		struct rb_node *node = parent->dir.children.rb_node;
>  		while (node) {
> @@ -1635,7 +1652,7 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
>  		}
>  	}
>  	/* Skip over entries which are dying/dead or in the wrong namespace */
> -	while (pos && (!kernfs_active(pos) || pos->ns != ns)) {
> +	while (pos && (!kernfs_active(pos) || (pos->ns != ns && pos->ns != init_ns))) {
>  		struct rb_node *node = rb_next(&pos->rb);
>  		if (!node)
>  			pos = NULL;
> @@ -1650,13 +1667,20 @@ static struct kernfs_node *kernfs_dir_next_pos(const void *ns,
>  {
>  	pos = kernfs_dir_pos(ns, parent, ino, pos);
>  	if (pos) {
> +		const void *init_ns;
> +		if (kernfs_init_ns_propagates(parent))
> +			init_ns = kernfs_init_ns(parent->ns_type);
> +		else
> +			init_ns = NULL;
> +
>  		do {
>  			struct rb_node *node = rb_next(&pos->rb);
>  			if (!node)
>  				pos = NULL;
>  			else
>  				pos = rb_to_kn(node);
> -		} while (pos && (!kernfs_active(pos) || pos->ns != ns));
> +		} while (pos && (!kernfs_active(pos) ||
> +				 (pos->ns != ns && pos->ns != init_ns)));
>  	}
>  	return pos;
>  }
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index 7c972c00f84a..74eb6c447361 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -80,6 +80,30 @@ static inline struct kernfs_node *kernfs_dentry_node(struct dentry *dentry)
>  	return d_inode(dentry)->i_private;
>  }
>  
> +#ifdef CONFIG_NET
> +extern struct net init_net;
> +#endif
> +
> +extern struct user_namespace init_user_ns;
> +
> +static inline const void *kernfs_init_ns(enum kobj_ns_type ns_type)
> +{
> +	switch (ns_type) {
> +	case KOBJ_NS_TYPE_NET:
> +#ifdef CONFIG_NET
> +		return &init_net;
> +#else
> +		break;
> +#endif
> +	case KOBJ_NS_TYPE_USER:
> +		return &init_user_ns;
> +	default:
> +		pr_debug("Unsupported namespace type %d for kernfs\n", ns_type);
> +	}
> +
> +	return NULL;
> +}
> +
>  extern const struct super_operations kernfs_sops;
>  extern struct kmem_cache *kernfs_node_cache, *kernfs_iattrs_cache;
>  
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 5e2ec88a709e..99b82a0ae7ea 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -43,6 +43,8 @@ static void sysfs_fs_context_free(struct fs_context *fc)
>  
>  	if (kfc->ns_tag[KOBJ_NS_TYPE_NET])
>  		kobj_ns_drop(KOBJ_NS_TYPE_NET, kfc->ns_tag[KOBJ_NS_TYPE_NET]);
> +	if (kfc->ns_tag[KOBJ_NS_TYPE_USER])
> +		kobj_ns_drop(KOBJ_NS_TYPE_USER, kfc->ns_tag[KOBJ_NS_TYPE_USER]);
>  	kernfs_free_fs_context(fc);
>  	kfree(kfc);
>  }
> @@ -67,6 +69,7 @@ static int sysfs_init_fs_context(struct fs_context *fc)
>  		return -ENOMEM;
>  
>  	kfc->ns_tag[KOBJ_NS_TYPE_NET] = netns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
> +	kfc->ns_tag[KOBJ_NS_TYPE_USER] = kobj_ns_grab_current(KOBJ_NS_TYPE_USER);

It's nice and tidy this way so maybe worth it, but getting
the kobj_ns_type_lock spinlock twice in a row here seems
unfortunate.

>  	kfc->root = sysfs_root;
>  	kfc->magic = SYSFS_MAGIC;
>  	fc->fs_private = kfc;
> @@ -85,6 +88,7 @@ static void sysfs_kill_sb(struct super_block *sb)
>  
>  	kernfs_kill_sb(sb);
>  	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns[KOBJ_NS_TYPE_NET]);
> +	kobj_ns_drop(KOBJ_NS_TYPE_USER, ns[KOBJ_NS_TYPE_USER]);
>  }
>  
>  static struct file_system_type sysfs_fs_type = {
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 9b3fffdf4011..4edf8a82e815 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -220,6 +220,9 @@ struct gendisk {
>  	int node_id;
>  	struct badblocks *bb;
>  	struct lockdep_map lockdep_map;
> +#ifdef CONFIG_BLK_DEV_LOOPFS
> +	struct user_namespace *user_ns;
> +#endif
>  };
>  
>  static inline struct gendisk *part_to_disk(struct hd_struct *part)
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index d0544f2e0c99..7809584a7c8e 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -53,6 +53,7 @@ enum kernfs_node_flag {
>  	KERNFS_SUICIDED		= 0x0800,
>  	KERNFS_EMPTY_DIR	= 0x1000,
>  	KERNFS_HAS_RELEASE	= 0x2000,
> +	KERNFS_NS_PROPAGATE	= 0x4000,
>  };
>  
>  /* @flags for kernfs_create_root() */
> @@ -337,6 +338,27 @@ static inline void kernfs_enable_ns(struct kernfs_node *kn,
>  	kn->ns_type = ns_type;
>  }
>  
> +static inline void kernfs_enable_init_ns_propagates(struct kernfs_node *kn)
> +{
> +	WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->dir.children));
> +	WARN_ON_ONCE(!(kn->flags & KERNFS_NS));
> +	kn->flags |= KERNFS_NS_PROPAGATE;
> +}
> +
> +/**
> + * kernfs_init_ns_propagates - test whether init ns propagates
> + * @kn: the node to test
> + *
> + * Test whether kernfs entries created in the init namespace propagate into
> + * other namespaces.
> + */
> +static inline bool kernfs_init_ns_propagates(const struct kernfs_node *kn)
> +{
> +	return ((kn->flags & (KERNFS_NS | KERNFS_NS_PROPAGATE)) ==
> +		(KERNFS_NS | KERNFS_NS_PROPAGATE));
> +}
> +
>  /**
>   * kernfs_ns_enabled - test whether namespace is enabled
>   * @kn: the node to test
> diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
> index 991a9286bcea..a9c45bcce235 100644
> --- a/include/linux/kobject_ns.h
> +++ b/include/linux/kobject_ns.h
> @@ -26,6 +26,7 @@ struct kobject;
>  enum kobj_ns_type {
>  	KOBJ_NS_TYPE_NONE = 0,
>  	KOBJ_NS_TYPE_NET,
> +	KOBJ_NS_TYPE_USER,
>  	KOBJ_NS_TYPES
>  };
>  
> @@ -34,6 +35,8 @@ enum kobj_ns_type {
>   *   @grab_current_ns: return a new reference to calling task's namespace
>   *   @initial_ns: return the initial namespace (i.e. init_net_ns)
>   *   @drop_ns: drops a reference to namespace
> + *   @initial_ns_propagates: whether devices in the initial namespace propagate
> + *			to all other namespaces
>   */
>  struct kobj_ns_type_operations {
>  	enum kobj_ns_type type;
> @@ -41,6 +44,7 @@ struct kobj_ns_type_operations {
>  	void *(*grab_current_ns)(void);
>  	const void *(*initial_ns)(void);
>  	void (*drop_ns)(void *);
> +	bool (*initial_ns_propagates)(void);
>  };
>  
>  int kobj_ns_type_register(const struct kobj_ns_type_operations *ops);
> diff --git a/lib/kobject.c b/lib/kobject.c
> index c58c62d49a10..96bb8c732d1c 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -121,6 +121,8 @@ static int create_dir(struct kobject *kobj)
>  		BUG_ON(!kobj_ns_type_registered(ops->type));
>  
>  		sysfs_enable_ns(kobj->sd, ops->type);
> +		if (ops->initial_ns_propagates && ops->initial_ns_propagates())
> +			kernfs_enable_init_ns_propagates(kobj->sd);
>  	}
>  
>  	return 0;
> -- 
> 2.26.1
